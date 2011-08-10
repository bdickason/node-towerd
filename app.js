(function() {
  var RedisStore, Users, World, app, cfg, express, gzippo, http, init, io, mongoose, sys, winston, world;
  http = require('http');
  express = require('express');
  RedisStore = (require('connect-redis'))(express);
  sys = require('sys');
  mongoose = require('mongoose');
  gzippo = require('gzippo');
  cfg = require('./config/config.js');
  init = require('./controllers/utils/init.js');
  winston = require('winston');
  console.log("Subdomain: " + cfg.LOGGLY_SUBDOMAIN + " input token: " + cfg.LOGGLY_INPUTTOKEN);
  global.logger = new winston.Logger({
    transports: [
      new winston.transports.Console({
        level: 'debug',
        colorize: true
      }), new winston.transports.Loggly({
        level: 'info',
        subdomain: cfg.LOGGLY_SUBDOMAIN,
        inputToken: cfg.LOGGLY_INPUTTOKEN
      })
    ]
  });
  app = express.createServer();
  io = (require('socket.io')).listen(app);
  app.configure(function() {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.register('.html', require('jade'));
    app.use(express.methodOverride());
    app.use(express.bodyParser());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: cfg.SESSION_SECRET,
      store: new RedisStore
    }));
    app.use(app.router);
    return app.use(gzippo.staticGzip(__dirname + '/public'));
  });
  mongoose.connection.on('open', function() {
    return console.log('Mongo is connected!');
  });
  app.dynamicHelpers({
    session: function(req, res) {
      return req.session;
    }
  });
  /* Spawn the world!! */
  console.log('Spawning New Game');
  World = (require('./world.js')).World;
  world = new World;
  global.world = world;
  world.emit('load');
  /* Initialize controllers */
  Users = (require('./controllers/user.js')).Users;
  /* Start Route Handling */
  app.get('/', function(req, res) {
    if (typeof world === 'undefined') {
      console.log('Game has not started yet.');
      return res.redirect('/');
    } else {
      return world.toString(function(json) {
        return res.render('game', {
          json: json
        });
      });
    }
    /* Handle logins
    if req.session.auth == 1
      # User is authenticated
      res.send 'done'
    else
      res.send "You are not logged in. <A HREF='/login'>Click here</A> to login"
    */
  });
  app.get('/start', function(req, res) {
    return res.redirect('/');
  });
  app.get('/end', function(req, res) {
    return world.destroy();
  });
  app.get('/register/:id/:name', function(req, res) {
    var user;
    console.log('TODO - Render registration page and ask for username');
    user = new Users;
    return user.addUser(req.params.id, req.params.name, function(json) {
      return console.log('Adding user: ' + req.params.id, req.params.name);
    });
  });
  app.get('/users', function(req, res) {
    var user;
    user = new Users;
    return user.get(null, function(json) {
      console.log('json: ' + json);
      return res.send(json);
    });
  });
  app.get('/users/:id', function(req, res) {
    var callback, user;
    callback = '';
    user = new Users;
    return user.get(req.params.id, function(json) {
      return res.send(json);
    });
  });
  app.get('/login', function(req, res) {
    if (req.session.auth === 1) {
      return res.redirect('/');
    } else {
      console.log('User logged in.');
      req.session.id = 0;
      req.session.name = 'verb';
      req.session.auth = 1;
      res.redirect('/');
      return console.log('TODO - Render Login page and ask for username');
    }
  });
  app.get('/logout', function(req, res) {
    console.log('--- LOGOUT ---');
    console.log(req.session);
    console.log('--- LOGOUT ---');
    req.session.destroy();
    return res.redirect('/');
  });
  app.listen(process.env.PORT || 3000);
  /* Socket.io Stuff */
  io.sockets.on('connection', function(socket) {
    socket.emit('test', {
      hello: 'world'
    });
    return socket.on('test event', function(data) {
      return console.log(data);
    });
  });
  /* Socket/World Event Listners */
}).call(this);
