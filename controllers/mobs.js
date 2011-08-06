(function() {
  var Mob, cfg, mobModel, redis;
  cfg = require('../config/config.js');
  redis = require('redis');
  mobModel = require('../models/mob-model.js');
  exports.Mob = Mob = (function() {
    function Mob(name) {
      var toLoad;
      name = name.toLowerCase();
      console.log('Loading mob: ' + name);
      toLoad = (require('../data/mobs/' + name + '.js')).mob;
      console.log(toLoad);
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id;
      this.name = toLoad.name;
      this["class"] = toLoad["class"];
      this.speed = toLoad.speed;
      this.maxHP = toLoad.maxHP;
      this.loc = {
        X: null,
        Y: null
      };
      this.curHP = null;
    }
    Mob.prototype.spawn = function(X, Y, callback) {
      this.loc.X = X;
      this.loc.Y = Y;
      this.curHP = this.maxHP;
      return console.log('Spawning mob [' + this.id + '] at (' + X + ',' + Y + ') with UID: ' + this.uid);
    };
    Mob.prototype.move = function(X, Y, callback) {
      this.loc.X = this.loc.X + X;
      this.loc.Y = this.loc.Y + Y;
      return console.log('MOB ' + this.uid + ' [' + this.id + '] moved to (' + this.loc.X + ',' + this.loc.Y + ')');
    };
    Mob.prototype.toString = function(callback) {
      var output;
      output = 'MOB ' + this.uid + ' [' + this.id + ']  loc: (' + this.loc.X + ', ' + this.loc.Y + ')  HP: ' + this.curHP + '/' + this.maxHP;
      return callback(output);
    };
    return Mob;
  })();
}).call(this);
