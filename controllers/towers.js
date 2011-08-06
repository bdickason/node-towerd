(function() {
  var Tower, cfg, mapModel, redis;
  cfg = require('../config/config.js');
  redis = require('redis');
  mapModel = require('../models/map-model.js');
  exports.Tower = Tower = (function() {
    function Tower(name) {
      var toLoad;
      name = name.toLowerCase();
      console.log('Loading tower: ' + name);
      toLoad = (require('../data/towers/' + name + '.js')).tower;
      console.log(toLoad);
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id;
      this.name = toLoad.name;
      this.damage = toLoad.damage;
      this.range = toLoad.range;
      this.type = toLoad.type;
      this.loc = {
        X: null,
        Y: null
      };
    }
    Tower.prototype.spawn = function(X, Y, callback) {
      this.loc.X = X;
      this.loc.Y = Y;
      return console.log('Spawning tower [' + this.name + '] at (' + X + ',' + Y + ') with UID: ' + this.uid);
    };
    Tower.prototype.checkTargets = function(callback) {};
    Tower.prototype.toString = function(callback) {
      var output;
      output = 'TOWER ' + this.uid + ' [' + this.id + ']  loc: (' + this.loc.X + ', ' + this.loc.Y + ')  Range: ' + this.range;
      return callback(output);
    };
    return Tower;
  })();
}).call(this);
