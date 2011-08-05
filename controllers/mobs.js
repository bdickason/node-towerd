(function() {
  var Mob, Mobs, cfg, redis;
  cfg = require('../config/config.js');
  redis = require('redis');
  Mob = require('../models/mob-model.js');
  exports.Mobs = Mobs = (function() {
    function Mobs(name) {
      var toLoad;
      console.log('Loading mob: ' + name);
      toLoad = (require('../data/mobs/' + name + '.js')).mob;
      console.log(toLoad);
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id;
      this.name = toLoad.name;
      this["class"] = toLoad["class"];
      this.speed = toLoad.speed;
      this.maxHP = toLoad.maxHP;
    }
    Mobs.prototype.spawn = function(X, Y, callback) {
      console.log('Spawning mob [' + this.id + '] at (' + X + ',' + Y + ') with UID: ' + this.uid);
      this.X = X;
      this.Y = Y;
      return this.curHP = this.maxHP;
    };
    Mobs.prototype.move = function(X, Y, callback) {
      this.X = this.X + X;
      this.Y = this.Y + Y;
      return console.log('mob [' + this.id + '] moved to (' + X + ',' + Y + ')');
    };
    return Mobs;
  })();
}).call(this);
