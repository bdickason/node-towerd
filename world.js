(function() {
  var EventEmitter, World, map, mob, tower;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  EventEmitter = (require('events')).EventEmitter;
  map = (require('./controllers/maps')).Map;
  mob = (require('./controllers/mobs')).Mob;
  tower = (require('./controllers/towers')).Tower;
  exports.World = World = (function() {
    __extends(World, EventEmitter);
    function World() {
      /* Initial config */      var self;
      this.gameTime = 3000;
      /* Start the game!! */
      this.game = setInterval(function() {
        return world.gameLoop();
      }, this.gameTime);
      self = this;
      this.load = setTimeout(function() {
        return self.loadEntities();
      }, 1000);
    }
    World.prototype.loadEntities = function(callback) {
      /* Load the map */      var mobId, _i, _j, _k, _l, _len, _len2, _len3, _len4, _map, _mob, _ref, _ref2, _ref3, _ref4, _tower;
      this.maps = [];
      this.maps.push(new map('hiddenvalley'));
      _ref = this.maps;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _map = _ref[_i];
        this.emit('load', 'map', _map);
      }
      /* Load and spawn the towers */
      this.towers = [];
      this.towers.push(new tower('cannon'));
      _ref2 = this.towers;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        _tower = _ref2[_j];
        this.emit('load', 'tower', _tower);
      }
      /* Load the mobs */
      this.mobs = [];
      _ref3 = this.maps;
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        _map = _ref3[_k];
        _ref4 = _map.mobs;
        for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
          mobId = _ref4[_l];
          _mob = new mob(mobId);
          this.mobs.push(_mob);
          this.emit('load', 'mob', _mob);
        }
      }
      this.mobs[0].emit('spawn', [0, 0]);
      this.mobs[1].emit('spawm', [1, 0]);
      return this.towers[0].emit('spawn', [4, 4]);
      /* Save everything to mongo
      @maps[0].save ->    
      
      console.log 'TOWERS!'
      console.log @towers
      @towers[0].save ->
      
      console.log 'MOBS!'
      console.log @mobs
      
      @mobs[0].save ->
      
      console.log 'MOBS!'
      console.log @mobs
      @mobs[1].save -> */
    };
    World.prototype.gameLoop = function() {
      return this.emit('gameLoop');
      /*for mob in @mobs
        mob.move 1, 1, (json) -> */
      /*@toString (json) ->
        console.log json */
    };
    World.prototype.destroy = function() {
      var maps, mobs, towers;
      console.log('DESTROYING the game ;(');
      clearInterval(this.game);
      maps = [];
      mobs = [];
      return towers = [];
    };
    World.prototype.toString = function(callback) {
      return callback(this.maps[0].grid);
    };
    /* Handle Event Emitters/Listeners */
    World.prototype.handleSpawn = function(type, loc, json) {
      var symbol, _i, _len, _map, _ref, _results;
      symbol = 0;
      switch (type) {
        case 'mob':
          symbol = 'm';
          break;
        case 'tower':
          symbol = 'T';
      }
      if (this.maps.length) {
        _ref = this.maps;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          _map = _ref[_i];
          console.log(loc);
          _results.push(_map.grid.set(loc, symbol));
        }
        return _results;
      }
    };
    World.prototype.handleMove = function(type, oldLoc, newLoc, json) {
      var tower, _i, _j, _len, _len2, _map, _ref, _ref2, _results;
      if (this.maps.length) {
        _ref = this.maps;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          _map = _ref[_i];
          _map.grid.set(oldLoc, 0);
          _map.grid.set(newLoc, 'm');
        }
      }
      if (this.towers.length) {
        _ref2 = this.towers;
        _results = [];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          tower = _ref2[_j];
          _results.push(tower.checkTargets(function(json) {}));
        }
        return _results;
      }
    };
    return World;
  })();
}).call(this);
