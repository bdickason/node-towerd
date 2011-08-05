(function() {
  var RedisStore, Users, app, cfg, express, gzippo, http, mongoose, sys;
  http = require('http');
  express = require('express');
  RedisStore = (require('connect-redis'))(express);
  sys = require('sys');
  mongoose = require('mongoose');
  gzippo = require('gzippo');
  cfg = require('./config/config.js');
  app = express.createServer();
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
  /* Initialize controllers */
  Users = (require('./controllers/user.js')).Users;
  /* Start Route Handling */
  app.get('/', function(req, res) {
    if (req.session.auth === 1) {
      console.log('do something');
      return res.send('done');
    } else {
      return res.send("You are not logged in. <A HREF='/login'>Click here</A> to login");
    }
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
}).call(this);
