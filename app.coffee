http = require 'http'
url = require 'url'
express = require 'express'
Redis = require 'redis'
RedisStore = (require 'connect-redis')(express)
sys = require 'sys'
cfg = require './config/config.js'    # contains API keys, etc.
init = require './controllers/utils/init.js'
winston = require 'winston'

# Setup logging
global.logger = new (winston.Logger)( {
  transports: [
    new (winston.transports.Console)({ level: 'debug', colorize: true }), # Should catch 'debug' levels (ideally error too but oh well)
    new (winston.transports.Loggly)({ level: 'info', subdomain: cfg.LOGGLY_SUBDOMAIN, inputToken: cfg.LOGGLY_INPUTTOKEN })
    ]
})

 
# Setup Server
app = express.createServer()
io = (require 'socket.io').listen app

# Start up redis to cache stuff
redis = Redis.createClient cfg.REDIS_PORT, cfg.REDIS_HOSTNAME
redis.on 'error', (err) ->
  console.log 'REDIS Error:' + err

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.register '.html', require 'jade'
  app.use express.methodOverride()
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session { secret: cfg.SESSION_SECRET, store: new RedisStore, key: cfg.SESSION_ID }
  app.use app.router
  app.use express.static __dirname + '/public'  

app.dynamicHelpers { session: (req, res) -> req.session }

# Initialize DB
global.db = require('./models/db').db

### Initialize controllers ###
Users = (require './controllers/user.js').Users
World = (require './world.js').World
### Start Route Handling ###

worlds = []

# Home Page
app.get '/', (req, res) ->
  load req.sessionID, (world) ->
    ###if typeof world == 'undefined'
      res.redirect '/'
    else
      # Game is loaded
      console.log req.sessionID ###
    res.render 'game', { }

# Debug mode!
app.get '/debug', (req, res) ->
  # Simple admin dashboard to monitor the current runtime of the server
  if typeof world == 'undefined'
    res.redirect '/'
  else
    # game is loaded
    world.getGameData (data) =>
      res.render 'debug', { }
    
app.get '/end', (req, res) ->
  world.destroy()


### Socket.io Stuff ###
# Note, may need authentication later: https://github.com/dvv/socket.io/commit/ff1bcf0fb2721324a20f9d7516ff32fbe893a693#L0R111

io.enable 'browser client minification'
io.set 'log level', 2

io.sockets.on 'connection', (socket) ->
  logger.debug 'A socket with ID: ' + socket.id + ' connected'
  
  # Stick the client in a game - right now we only have one
  redis.get 'world', (err, worldId) ->    
    uid = Number worldId
    for _world in worlds
      if _world.uid == uid
        world = _world
        setupWorld socket, world
        
        ### Socket Event Listeners ###
        # 
        # These are events coming from the client

        socket.on 'start', ->
          world.start()

        socket.on 'pause', ->
          world.pause()

        socket.on 'disconnect', ->
          logger.debug 'A socket with the session ID: ' + socket.id + ' disconnected.'

        socket.on 'add', (type, x, y) ->
          logger.info "Client added a tower: #{type} at #{x} #{y}"
          world.add type, x, y

        socket.on 'debug', ->
          world.getGameData (data) =>
            # Trim the graph out of the initial client data dump
            data.map.type = 'map'
            data.map = filter data.map

            socket.volatile.emit 'debug', data
  
load = (sessionID, callback) ->
  ### Spawn the world!! ###
  logger.info 'Spawning New Game'  
  world = new World 
  console.log sessionID
  world.add 'player', sessionID
  worlds.push world
  redis.set 'world', world.uid
  # global.world = world  # world needs to be called from anywhere/everywhere
  world.emit 'load'
  callback world

filter = (obj) ->
  # Filters out unwanted game data to send to the client
  # This is to keep packets as small as possible
  switch obj.type
    when 'mob'
      newobj = { uid: obj.uid, x: obj.x, y: obj.y, dx: obj.dx, dy: obj.dy, speed: obj.speed, maxHP: obj.maxHP, curHP: obj.curHP, symbol: obj.symbol, type: obj.type }
    when 'tower'
      newobj = { uid: obj.uid, x: obj.x, y: obj.y, symbol: obj.symbol, damage: obj.damage, type: obj.type }
    when 'map'
      newobj = { name: obj.name, uid: obj.uid, size: obj.size, end_x: obj.end_x, end_y: obj.end_y, type: obj.type }
  return newobj

setupWorld = (socket, world) ->
  # When a client connects, we should dump the current gamestate  
  world.getGameData (data) ->
    # Trim the graph out of the initial client data dump
    data.map.type = 'map'
    data.map = filter data.map
    socket.emit 'init', { data: data }

  ### World Event Listeners ###
  # 
  # These are events coming from the world (so send 'em to the client!)
  
  world.on 'load', (obj) ->
    # Tell the client to load some game data
    socket.emit 'load ', filter obj
  
  world.on 'spawn', (obj) ->
    # Tell the client to spawn an object
    socket.emit 'spawn', filter obj
  
  world.on 'gameLoop', ->

  world.on 'move', (obj) ->
    # object is moving from oldloc to obj.loc
    socket.emit 'move', filter obj
  
  world.on 'fire', (obj, target) ->
    # object fired on target
    obj = filter obj
    target = filter target
    socket.emit 'fire', { obj, target }
  
  world.on 'hit', (obj) ->
    socket.emit 'hit', filter obj
  
  world.on 'die', (obj) ->
    # someone died ;(
    socket.emit 'die', filter obj
    

app.listen process.env.PORT or 3000 