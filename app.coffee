http = require 'http'
url = require 'url'
express = require 'express'
redis = require 'redis'
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


app.configure 'production', ->
  # Configure redistogo for heroku (production)
  redisUrl = url.parse cfg.REDISTOGO_URL
  redisAuth = redisUrl.auth.split ':'
  app.set 'redisHost', redisUrl.hostname
  app.set 'redisPort', redisUrl.port 
  app.set 'redisDb', redisAuth[0]
  app.set 'redisPass', redisAuth[1]
    
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

# Home Page
app.get '/', (req, res) ->
  if typeof world == 'undefined'
    res.redirect '/'
  else
    # Game is loaded
    res.render 'game', { }

  ### Handle logins
  if req.session.auth == 1
    # User is authenticated
    res.send 'done'
  else
    res.send "You are not logged in. <A HREF='/login'>Click here</A> to login"
  ###
  
app.get '/end', (req, res) ->
  world.destroy()


### Socket.io Stuff ###
# Note, may need authentication later: https://github.com/dvv/socket.io/commit/ff1bcf0fb2721324a20f9d7516ff32fbe893a693#L0R111

io.enable 'browser client minification'
# io.set 'log level', 1

io.sockets.on 'connection', (socket) ->
  logger.debug 'A socket with ID: ' + socket.id + ' connected'
  
  ### Load core game data ###
  # 
  loadWorld(socket)

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
    
### Will use later ###
app.get '/register/:id/:name', (req, res) ->
  # Allow a user to register
  console.log 'TODO - Render registration page and ask for username'
  user = new Users
  user.addUser req.params.id, req.params.name, (json) ->
    console.log 'Adding user: ' + req.params.id, req.params.name

# List All Users
app.get '/users', (req, res) ->
  user = new Users
  user.get null, (json) ->
    res.send json
    # res.render 'users', { json: json }

# Single User Profile
app.get '/users/:id', (req, res) ->
  callback = ''
  user = new Users
  user.get req.params.id, (json) ->
    res.send json
    # res.render 'users/singleUser', { json: json }

app.get '/login', (req, res) ->
  if req.session.auth == 1
    # User is already auth'd
    res.redirect '/'
  else
    logger.info 'User logged in.'
    req.session.id = 0
    req.session.name = 'verb'
    req.session.auth = 1
    res.redirect '/'
    logger.warning 'TODO - Render Login page and ask for username'
  
app.get '/logout', (req, res) ->
  logger.info '--- LOGOUT ---'
  logger.info req.session
  req.session.destroy()
  res.redirect '/'
  
load = ->
  ### Spawn the world!! ###
  logger.info 'Spawning New Game'  
  world = new World app
  global.world = world  # world needs to be called from anywhere/everywhere
  world.emit 'load'

filter = (obj) ->
  # Filters out unwanted game data to send to the client
  # This is to keep packets as small as possible
  switch obj.type
    when 'mob'
      newobj = { uid: obj.uid, x: obj.x, y: obj.y, dx: obj.dx, dy: obj.dy, speed: obj.speed, maxHP: obj.maxHP, curHP: obj.curHP, symbol: obj.symbol }
    when 'tower'
      newobj = { uid: obj.uid, x: obj.x, y: obj.y, symbol: obj.symbol, damage: obj.damage, type: obj.type }
    when 'map'
      newobj = { uid: obj.uid, size: obj.size, end_x: obj.end_x, end_y: obj.end_y, type: obj.type }
  return newobj

loadWorld = (socket) ->
  # Fix - Clients connecting the moment the server was started would crash it
  if world.loaded
    setupWorld socket
  else
    # World isn't ready, wait 1000ms and try again!
    retryLoad = setTimeout =>
      loadWorld socket
    , 1000

setupWorld = (socket) ->
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

  world.on 'move', (obj) ->
    # object is moving from oldloc to obj.loc
    socket.emit 'move', filter obj
  
  world.on 'fire', (obj, target) ->
    # object fired on target
    obj = filter obj
    target = filter target
    socket.emit 'fire', { obj, target }
      
load()  # Load basic game info

app.listen process.env.PORT or 3000 