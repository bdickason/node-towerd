(function() {
  /* World - Runs the game world like a pro! */  var EventEmitter, Map, Mob, Player, Tower, World, cfg;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __slice = Array.prototype.slice;
  EventEmitter = (require('events')).EventEmitter;
  cfg = require('./config/config.js');
  Map = (require('./controllers/maps')).Map;
  Mob = (require('./controllers/mobs')).Mob;
  Tower = (require('./controllers/towers')).Tower;
  Player = (require('./controllers/player')).Player;
  exports.World = World = (function() {
    __extends(World, EventEmitter);
    function World() {
      /* Initial config */      this.maxPlayers = 2;
      this.players = [];
      this.uid = Math.floor(Math.random() * 10000000);
      this.gameTime = cfg.GAMETIMER;
      this.loaded = false;
      this.loadEntities({
        map: 'hiddenvalley'
      });
    }
    /* Start the game!! */
    World.prototype.start = function() {
      var mob, _i, _len, _ref, _results;
      this.game = setInterval(__bind(function() {
        return this.gameLoop();
      }, this), this.gameTime);
      _ref = this.mobs;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mob = _ref[_i];
        mob.dx = 1;
        _results.push(mob.dy = 1);
      }
      return _results;
    };
    World.prototype.pause = function() {
      return clearTimeout(this.game);
    };
    World.prototype.loadEntities = function(json, callback) {
      /* Load the map */      var map, mob, mobId, tower, _i, _j, _k, _l, _len, _len2, _len3, _len4, _ref, _ref2, _ref3, _ref4;
      this.maps = [];
      this.maps.push(new Map(json.map, this));
      _ref = this.maps;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        map = _ref[_i];
        this.loadobj(map);
      }
      /* Load and spawn the towers */
      this.towers = [];
      this.towers.push(new Tower('cannon', this));
      _ref2 = this.towers;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        tower = _ref2[_j];
        this.loadobj(tower);
      }
      /* Load the mobs */
      this.mobs = [];
      _ref3 = this.maps;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        map = _ref3[_k];
        _ref4 = map.mobs;
        for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
          mobId = _ref4[_l];
          mob = new Mob(mobId, this);
          this.mobs.push(mob);
          this.loadobj(mob);
        }
      }
      this.mobs[0].spawn(this.maps[0].start_x, this.maps[0].start_y, 0, 0, this.maps[0].end_x, this.maps[0].end_y);
      this.mobs[1].spawn(this.maps[0].start_x, this.maps[0].start_y + 1, 0, 0, this.maps[0].end_x, this.maps[0].end_y);
      this.towers[0].spawn(4, 4);
      return this.loaded = true;
    };
    World.prototype.add = function() {
      var params, tower, type;
      type = arguments[0], params = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      switch (type) {
        case 'tower':
          tower = new Tower('cannon', this);
          this.towers.push(tower);
          this.loadobj(tower);
          console.log('spawning tower');
          this.towers[this.towers.length - 1].spawn(params[0], params[1]);
          return this.toString(function(json) {
            return console.log(json);
          });
        case 'player':
          return this.players.push(new Player(params[0], this));
      }
    };
    World.prototype.loadobj = function(obj) {
      this.emit('load', obj);
      /* Event Emitters - set them up! */
      obj.on('spawn', __bind(function() {
        return this.spawnobj(obj);
      }, this));
      obj.on('move', __bind(function(old_x, old_y) {
        return this.moveobj(obj, old_x, old_y);
      }, this));
      obj.on('fire', __bind(function(target) {
        return this.fireobj(obj, target);
      }, this));
      obj.on('die', __bind(function() {
        return this.killobj(obj);
      }, this));
      return obj.on('hit', __bind(function() {
        return this.hitobj(obj);
      }, this));
    };
    /* Event functions */
    World.prototype.spawnobj = function(obj) {
      return this.emit('spawn', obj);
    };
    World.prototype.moveobj = function(obj, old_x, old_y) {
      if (this.maps[0].graph.isInGraph(obj.x, obj.y)) {
        return this.emit('move', obj, old_x, old_y);
      }
    };
    World.prototype.fireobj = function(obj, target) {
      return this.emit('fire', obj, target);
    };
    World.prototype.killobj = function(obj) {
      return this.emit('die', obj);
    };
    World.prototype.hitobj = function(obj) {
      return this.emit('hit', obj);
    };
    World.prototype.gameLoop = function() {
      this.emit('gameLoop');
      return this.toString(function(json) {
        return console.log(json);
      });
    };
    World.prototype.getGameData = function(callback) {
      var data;
      data = {
        cfg: cfg.TILESIZE,
        map: this.maps[0],
        mobs: this.mobs,
        towers: this.towers
      };
      return callback(data);
    };
    World.prototype.destroy = function() {
      var maps, mobs, towers;
      logger.info('DESTROYING the game ;(');
      clearInterval(this.game);
      maps = [];
      mobs = [];
      return towers = [];
    };
    World.prototype.toString = function(callback) {
      return callback(this.maps[0].graph.toString());
    };
    return World;
  })();
}).call(this);
