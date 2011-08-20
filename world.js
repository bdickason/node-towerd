(function() {
  /* World - Runs the game world like a pro! */  var EventEmitter, Map, Mob, Tower, World, cfg;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  EventEmitter = (require('events')).EventEmitter;
  cfg = require('./config/config.js');
  Map = (require('./controllers/maps')).Map;
  Mob = (require('./controllers/mobs')).Mob;
  Tower = (require('./controllers/towers')).Tower;
  exports.World = World = (function() {
    __extends(World, EventEmitter);
    function World(app) {
      /* Initial config */      this.gameTime = cfg.GAMETIMER;
      this.load = setTimeout(__bind(function() {
        return this.loadEntities({
          map: 'hiddenvalley'
        });
      }, this), 1000);
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
      this.maps.push(new Map(json.map));
      _ref = this.maps;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        map = _ref[_i];
        this.loadobj(map);
      }
      /* Load and spawn the towers */
      this.towers = [];
      this.towers.push(new Tower('cannon'));
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
          mob = new Mob(mobId);
          this.mobs.push(mob);
          this.loadobj(mob);
        }
      }
      this.mobs[0].spawn(0, 1, 0, 0);
      this.mobs[1].spawn(1, 1, 0, 0);
      return this.towers[0].spawn(4, 4);
    };
    World.prototype.add = function(type, x, y) {
      var tower;
      switch (type) {
        case 'tower':
          tower = new Tower('cannon');
          this.towers.push(tower);
          this.loadobj(tower);
          return this.towers[this.towers.length - 1].spawn(x, y);
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
      return obj.on('fire', __bind(function(target) {
        return this.fireobj(obj, target);
      }, this));
    };
    /* Event functions */
    World.prototype.spawnobj = function(obj) {
      return this.emit('spawn', obj);
    };
    World.prototype.moveobj = function(obj, old_x, old_y) {
      if (this.maps[0].grid.isInGrid(obj.x, obj.y)) {
        return this.emit('move', obj, old_x, old_y);
      }
    };
    World.prototype.fireobj = function(obj, target) {
      return this.emit('fire', obj, target);
    };
    World.prototype.gameLoop = function() {
      return this.emit('gameLoop');
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
      return callback(this.maps[0].grid);
    };
    return World;
  })();
}).call(this);
