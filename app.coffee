http = require 'http'
express = require 'express'
redis = require 'redis'
RedisStore = (require 'connect-redis')(express)
sys = require 'sys'
cfg = require './config/config.js'    # contains API keys, etc.
init = require './controllers/utils/init.js'
winston = require 'winston'
connect = require 'express/node_modules/connect'

# Setup logging
global.logger = new (winston.Logger)( {
  transports: [
    new (winston.transports.Console)({ level: 'debug', colorize: true }), # Should catch 'debug' levels (ideally error too but oh well)
    new (winston.transports.Loggly)({ level: 'info', subdomain: cfg.LOGGLY_SUBDOMAIN, inputToken: cfg.LOGGLY_INPUTTOKEN })
    ]
})

# Setup Memory Store (split it out so socket.io can leverage it)
redis_store = new RedisStore
 
# Setup Server
app = express.createServer()
io = (require 'socket.io').listen app

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.register '.html', require 'jade'
  app.use express.methodOverride()
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session { secret: cfg.SESSION_SECRET, store: redis_store, key: cfg.SESSION_ID }
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
    load()  # Load basic game info
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

### Start a new game! ###
app.get '/start', (req, res) ->
  world.start()  # Start the game!
  res.redirect '/'
    
  
app.get '/end', (req, res) ->
  world.destroy()

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
  
app.listen process.env.PORT or 3000 

### Socket.io Stuff ###

# handle cookies and sessions for socket clients
parseCookie = connect.utils.parseCookie; # Needed for socket.io cookies
Session = connect.middleware.session.Session

io.set 'authorization', (data, accept) ->
  if data.headers.cookie
    data.cookie = parseCookie data.headers.cookie
    data.sessionID = data.cookie[cfg.SESSION_ID]
    # save the session store to the data object (required by Session constructor)
    data.sessionStore = redis_store
    redis_store.get data.sessionID, (err, session) ->
      if err
        # if we can't grab a session, turn down the connection
        accept err.message, false
      else
        # save the session and accept the connection
        data.session = session
        accept null, true
  else
    # Create a session passing data and new session data
    data.session = new Session data, session
    accept 'No cookie transmitted', false
  accept null, true

io.sockets.on 'connection', (socket) ->
  hs = socket.handshake
  logger.debug 'A socket with conncetion ID: ' + hs.sessionID + ' connected.'

  # setup an interval that will keep our session fresh
  intervalID = setInterval () ->
    # reload the session, in case something changed
    console.log hs.session
    hs.session.reload ->
      hs.session.touch().save()
  , 60 * 1000
    
  ### Socket/World Event Listeners ###
  # 
  # This is the stuff that ties the game to the client

  world.on 'load', (type, obj) ->
    switch type
      when 'mob'
        logger.debug 'mob loaded with uid: ' + obj.uid
        socket.emit 'load', { obj: obj, type: type }
      
        obj.on 'move', (type, oldloc, newloc) ->
          logger.debug 'mob moving to loc: ' + obj.loc
          socket.emit 'move'
                  
      when 'tower'
        logger.debug 'tower loaded'
        socket.emit 'load ', { obj: obj, type: type }
  
  socket.on 'disconnect', ->
    # clear the socket interval to stop refreshing the session
    logger.debug 'A socket with the session ID: ' + hs.sessionID + ' disconnected.'
    clearInterval intervalID