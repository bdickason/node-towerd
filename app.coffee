http = require 'http'
express = require 'express'
RedisStore = (require 'connect-redis')(express)
sys = require 'sys'
mongoose = require 'mongoose'
gzippo = require 'gzippo'
cfg = require './config/config.js'    # contains API keys, etc.


app = express.createServer()

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.register '.html', require 'jade'
  app.use express.methodOverride()
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session { secret: cfg.SESSION_SECRET, store: new RedisStore}
  app.use app.router
  app.use(gzippo.staticGzip(__dirname + '/public'));  
  
mongoose.connection.on 'open', ->
  console.log 'Mongo is connected!'
  
app.dynamicHelpers { session: (req, res) -> req.session }

### Initialize controllers ###
World = (require './controllers/world.js').World
Users = (require './controllers/user.js').Users

### Start Route Handling ###

# Home Page
app.get '/', (req, res) ->
  if typeof world == 'undefined'
    console.log 'Game has not started yet.'
    res.redirect '/start'
  else
    world.toString (json) ->
      res.send json

  ### Handle logins
  if req.session.auth == 1
    # User is authenticated
    res.send 'done'
  else
    res.send "You are not logged in. <A HREF='/login'>Click here</A> to login"
  ###

# Start a new game!
app.get '/start', (req, res) ->
  console.log 'Spawning New Game'

  world = new World
  global.world = world  # world needs to be called from anywhere/everywhere
  
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
    console.log 'json: ' + json
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
    console.log 'User logged in.'
    req.session.id = 0
    req.session.name = 'verb'
    req.session.auth = 1
    res.redirect '/'
    console.log 'TODO - Render Login page and ask for username'
  
app.get '/logout', (req, res) ->
  console.log '--- LOGOUT ---'
  console.log req.session
  console.log '--- LOGOUT ---'
  req.session.destroy()
  res.redirect '/'
  


app.listen process.env.PORT or 3000 