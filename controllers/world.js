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
  map = (require('./maps')).Map;
  mob = (require('./mobs')).Mob;
  tower = (require('./towers')).Tower;
  EventEmitter = (require('events')).EventEmitter;
  exports.World = World = (function() {
    __extends(World, EventEmitter);
    function World() {
      /* Initial config */      var self;
      this.gameTime = 3000;
      /* Start the game!! */
      this.game = setInterval(function() {
        return world.gameLoop();
      }, this.gameTime);
      /* Load the map */
      this.maps = [];
      this.maps.push(new map('hiddenvalley'));
      /* Load the mobs */
      this.mobs = [];
      this.mobs.push(new mob(this.maps[0].mobs[0]));
      this.mobs.push(new mob(this.maps[0].mobs[0]));
      /* Load the towers */
      this.towers = [];
      this.towers.push(new tower('cannon'));
      self = this;
      this.towers[0].on('spawn', function(type, loc, json) {
        return self.handleSpawn(type, loc, function(json) {
          return console.log('finished spawn');
        });
      });
      this.mobs[0].on('spawn', function(type, loc, json) {
        return self.handleSpawn(type, loc, function(json) {
          return console.log('finished spawn');
        });
      });
      this.mobs[1].on('spawn', function(type, loc, json) {
        return self.handleSpawn(type, loc, function(json) {
          return console.log('finished spawn');
        });
      });
      this.mobs[0].on('move', function(type, oldLoc, newLoc, json) {
        return self.handleMove(type, oldLoc, newLoc, function(json) {
          return console.log('finished move');
        });
      });
      this.mobs[1].on('move', function(type, oldLoc, newLoc, json) {
        return self.handleMove(type, oldLoc, newLoc, function(json) {
          return console.log('finished move');
        });
      });
      this.mobs[0].spawn(0, 0, function(json) {
        return console.log('Mob: ' + mob);
      });
      this.mobs[1].spawn(1, 0, function(json) {
        return console.log('Mob: ' + mob);
      });
      this.towers[0].spawn(4, 4, function(json) {
        return console.log('Tower: ' + json);
      });
      this.maps[0].save(function() {});
      this.towers[0].save(function() {});
      this.mobs[0].save(function() {});
      this.mobs[1].save(function() {});
    }
    World.prototype.gameLoop = function() {
      var mob, _i, _len, _ref;
      this.emit('gameLoop');
      _ref = this.mobs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mob = _ref[_i];
        mob.move(1, 1, function(json) {});
      }
      return this.toString(function(json) {
        return console.log(json);
      });
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
      return callback(this.maps[0].grid.grid);
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
