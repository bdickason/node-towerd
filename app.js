(function() {
  var Redis, RedisStore, Users, World, app, cfg, express, filter, http, init, io, load, redis, setupWorld, sys, url, winston, worlds;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  http = require('http');
  url = require('url');
  express = require('express');
  Redis = require('redis');
  RedisStore = (require('connect-redis'))(express);
  sys = require('sys');
  cfg = require('./config/config.js');
  init = require('./controllers/utils/init.js');
  winston = require('winston');
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
  redis = Redis.createClient(cfg.REDIS_PORT, cfg.REDIS_HOSTNAME);
  redis.on('error', function(err) {
    return console.log('REDIS Error:' + err);
  });
  app.configure(function() {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.register('.html', require('jade'));
    app.use(express.methodOverride());
    app.use(express.bodyParser());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: cfg.SESSION_SECRET,
      store: new RedisStore,
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
  worlds = [];
  app.get('/', function(req, res) {
    return load(req.sessionID, function(world) {
      /*if typeof world == 'undefined'
        res.redirect '/'
      else
        # Game is loaded
        console.log req.sessionID */      return res.render('game', {});
    });
  });
  app.get('/debug', function(req, res) {
    if (typeof world === 'undefined') {
      return res.redirect('/');
    } else {
      return world.getGameData(__bind(function(data) {
        return res.render('debug', {});
      }, this));
    }
  });
  app.get('/end', function(req, res) {
    return world.destroy();
  });
  /* Socket.io Stuff */
  io.enable('browser client minification');
  io.set('log level', 2);
  io.sockets.on('connection', function(socket) {
    logger.debug('A socket with ID: ' + socket.id + ' connected');
    return redis.get('world', function(err, worldId) {
      var uid, world, _i, _len, _results, _world;
      uid = Number(worldId);
      _results = [];
      for (_i = 0, _len = worlds.length; _i < _len; _i++) {
        _world = worlds[_i];
        _results.push((function() {
          if (_world.uid === uid) {
            world = _world;
            setupWorld(socket, world);
            /* Socket Event Listeners */
            socket.on('start', function() {
              return world.start();
            });
            socket.on('pause', function() {
              return world.pause();
            });
            socket.on('disconnect', function() {
              return logger.debug('A socket with the session ID: ' + socket.id + ' disconnected.');
            });
            socket.on('add', function(type, x, y) {
              logger.info("Client added a tower: " + type + " at " + x + " " + y);
              return world.add(type, x, y);
            });
            return socket.on('debug', function() {
              return world.getGameData(__bind(function(data) {
                data.map.type = 'map';
                data.map = filter(data.map);
                return socket.volatile.emit('debug', data);
              }, this));
            });
          }
        })());
      }
      return _results;
    });
  });
  load = function(sessionID, callback) {
    /* Spawn the world!! */    var world;
    logger.info('Spawning New Game');
    world = new World;
    console.log(sessionID);
    world.add('player', sessionID);
    worlds.push(world);
    redis.set('world', world.uid);
    world.emit('load');
    return callback(world);
  };
  filter = function(obj) {
    var newobj;
    switch (obj.type) {
      case 'mob':
        newobj = {
          uid: obj.uid,
          x: obj.x,
          y: obj.y,
          dx: obj.dx,
          dy: obj.dy,
          speed: obj.speed,
          maxHP: obj.maxHP,
          curHP: obj.curHP,
          symbol: obj.symbol
        };
        break;
      case 'tower':
        newobj = {
          uid: obj.uid,
          x: obj.x,
          y: obj.y,
          symbol: obj.symbol,
          damage: obj.damage,
          type: obj.type
        };
        break;
      case 'map':
        newobj = {
          name: obj.name,
          uid: obj.uid,
          size: obj.size,
          end_x: obj.end_x,
          end_y: obj.end_y,
          type: obj.type
        };
    }
    return newobj;
  };
  setupWorld = function(socket, world) {
    world.getGameData(function(data) {
      data.map.type = 'map';
      data.map = filter(data.map);
      return socket.emit('init', {
        data: data
      });
    });
    /* World Event Listeners */
    world.on('load', function(obj) {
      return socket.emit('load ', filter(obj));
    });
    world.on('spawn', function(obj) {
      return socket.emit('spawn', filter(obj));
    });
    world.on('gameLoop', function() {});
    world.on('move', function(obj) {
      return socket.emit('move', filter(obj));
    });
    world.on('fire', function(obj, target) {
      obj = filter(obj);
      target = filter(target);
      return socket.emit('fire', {
        obj: obj,
        target: target
      });
    });
    world.on('hit', function(obj) {
      return socket.emit('hit', filter(obj));
    });
    return world.on('die', function(obj) {
      return socket.emit('die', filter(obj));
    });
  };
  app.listen(process.env.PORT || 3000);
}).call(this);
