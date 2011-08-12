(function() {
  var RedisStore, Session, Users, World, app, cfg, connect, express, http, init, io, load, parseCookie, redis, redis_store, sys, winston;
  http = require('http');
  express = require('express');
  redis = require('redis');
  RedisStore = (require('connect-redis'))(express);
  sys = require('sys');
  cfg = require('./config/config.js');
  init = require('./controllers/utils/init.js');
  winston = require('winston');
  connect = require('express/node_modules/connect');
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
  redis_store = new RedisStore;
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
      store: redis_store,
      key: cfg.SESSION_ID
    }));
    app.use(app.router);
    return app.use(express.static(__dirname + '/public'));
  });
  app.dynamicHelpers({
    session: function(req, res) {
      return req.session;
    }
  });
  global.db = require('./models/db').db;
  /* Initialize controllers */
  Users = (require('./controllers/user.js')).Users;
  World = (require('./world.js')).World;
  /* Start Route Handling */
  app.get('/', function(req, res) {
    if (typeof world === 'undefined') {
      load();
      return res.redirect('/');
    } else {
      return res.render('game', {});
    }
    /* Handle logins
    if req.session.auth == 1
      # User is authenticated
      res.send 'done'
    else
      res.send "You are not logged in. <A HREF='/login'>Click here</A> to login"
    */
  });
  /* Start a new game! */
  app.get('/start', function(req, res) {
    world.start();
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
      logger.info('User logged in.');
      req.session.id = 0;
      req.session.name = 'verb';
      req.session.auth = 1;
      res.redirect('/');
      return logger.warning('TODO - Render Login page and ask for username');
    }
  });
  app.get('/logout', function(req, res) {
    logger.info('--- LOGOUT ---');
    logger.info(req.session);
    req.session.destroy();
    return res.redirect('/');
  });
  load = function() {
    /* Spawn the world!! */    var world;
    logger.info('Spawning New Game');
    world = new World(app);
    global.world = world;
    return world.emit('load');
  };
  app.listen(process.env.PORT || 3000);
  /* Socket.io Stuff */
  parseCookie = connect.utils.parseCookie;
  Session = connect.middleware.session.Session;
  io.set('authorization', function(data, accept) {
    if (data.headers.cookie) {
      data.cookie = parseCookie(data.headers.cookie);
      data.sessionID = data.cookie[cfg.SESSION_ID];
      data.sessionStore = redis_store;
      redis_store.get(data.sessionID, function(err, session) {
        if (err) {
          return accept(err.message, false);
        } else {
          data.session = session;
          return accept(null, true);
        }
      });
    } else {
      data.session = new Session(data, session);
      accept('No cookie transmitted', false);
    }
    return accept(null, true);
  });
  io.sockets.on('connection', function(socket) {
    var hs, intervalID;
    hs = socket.handshake;
    logger.debug('A socket with conncetion ID: ' + hs.sessionID + ' connected.');
    intervalID = setInterval(function() {
      console.log(hs.session);
      return hs.session.reload(function() {
        return hs.session.touch().save();
      });
    }, 60 * 1000);
    /* Socket/World Event Listeners */
    world.on('load', function(type, obj) {
      switch (type) {
        case 'mob':
          logger.debug('mob loaded with uid: ' + obj.uid);
          socket.emit('load', {
            obj: obj,
            type: type
          });
          return obj.on('move', function(type, oldloc, newloc) {
            logger.debug('mob moving to loc: ' + obj.loc);
            return socket.emit('move');
          });
        case 'tower':
          logger.debug('tower loaded');
          return socket.emit('load ', {
            obj: obj,
            type: type
          });
      }
    });
    return socket.on('disconnect', function() {
      logger.debug('A socket with the session ID: ' + hs.sessionID + ' disconnected.');
      return clearInterval(intervalID);
    });
  });
}).call(this);
