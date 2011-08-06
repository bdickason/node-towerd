(function() {
  var Game, map, mob, tower;
  map = (require('./maps')).Map;
  mob = (require('./mobs')).Mob;
  tower = (require('./towers')).Tower;
  exports.Game = Game = (function() {
    function Game() {
      /* Load the map */      this.maps = [];
      this.maps.push(new map('hiddenvalley'));
      console.log(this.maps);
      /* Load the mobs */
      this.mobs = [];
      this.mobs.push(new mob('warrior'));
      this.mobs.push(new mob('warrior'));
      this.mobs[0].spawn(0, 0, function(json) {
        return console.log('Mob: ' + mob);
      });
      this.mobs[1].spawn(1, 0, function(json) {
        return console.log('Mob: ' + mob);
      });
      this.mobs[0].move(1, 0, function(json) {});
      this.mobs[1].move(0, 1, function(json) {});
      this.mobs[0].toString(function(json) {
        return console.log(json);
      });
      this.mobs[1].toString(function(json) {
        return console.log(json);
      });
      /* Load the towers */
      this.towers = [];
      this.towers.push(new tower('cannon'));
      this.towers[0].spawn(5, 5, function(json) {
        return console.log('Tower: ' + tower);
      });
      this.towers[0].toString(function(json) {
        return console.log(json);
      });
    }
    Game.prototype.destroy = function() {
      var maps, mobs, towers;
      console.log('DESTROYING the game ;(');
      maps = [];
      mobs = [];
      return towers = [];
    };
    Game.prototype.toString = function(json) {
      var map, mob, tower, _fn, _fn2, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3, _results;
      _ref = this.maps;
      _fn = function(map) {
        return map.toString(function(json) {
          return console.log(json);
        });
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        map = _ref[_i];
        _fn(map);
      }
      _ref2 = this.mobs;
      _fn2 = function(mob) {
        return mob.toString(function(json) {
          return console.log(json);
        });
      };
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        mob = _ref2[_j];
        _fn2(mob);
      }
      _ref3 = this.towers;
      _results = [];
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        tower = _ref3[_k];
        _results.push((function(tower) {
          return tower.toString(function(json) {
            return console.log(json);
          });
        })(tower));
      }
      return _results;
    };
    return Game;
  })();
}).call(this);
