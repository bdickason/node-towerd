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
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id;
      this.name = toLoad.name;
      this["class"] = toLoad["class"];
      this.speed = toLoad.speed;
      this.maxHP = toLoad.maxHP;
      this.loc = [null, null];
      this.curHP = null;
    }
    Mob.prototype.spawn = function(X, Y, callback) {
      this.loc = [X, Y];
      this.curHP = this.maxHP;
      return console.log('Spawning mob [' + this.id + '] at (' + X + ',' + Y + ') with UID: ' + this.uid);
    };
    Mob.prototype.move = function(X, Y, callback) {
      var newloc;
      this.loc = [this.loc[0] + X, this.loc[1] + Y];
      newloc = this.loc;
      mobModel.find({
        uid: this.uid
      }, function(err, mob) {
        if (err) {
          return console.log('Error finding mob: {@uid} ' + err);
        } else {
          mob[0].loc = newloc;
          return mob[0].save(function(err) {
            if (err) {
              return console.log('Error saving mob: {@uid} ' + err);
            }
          });
        }
      });
      return console.log('MOB ' + this.uid + ' [' + this.id + '] moved to (' + this.loc[0] + ',' + this.loc[1] + ')');
    };
    Mob.prototype.save = function(callback) {
      var newmob;
      newmob = new mobModel({
        uid: this.uid,
        id: this.id,
        name: this.name,
        "class": this["class"],
        speed: this.speed,
        maxHP: this.maxHP,
        curHP: this.curHP,
        loc: this.loc
      });
      return newmob.save(function(err, saved) {
        if (err) {
          return console.log('Error saving: ' + err);
        } else {
          return console.log('Saved Mob: ' + newmob.uid);
        }
      });
    };
    Mob.prototype.toString = function(callback) {
      var output;
      output = 'MOB ' + this.uid + ' [' + this.id + ']  loc: (' + this.loc[0] + ', ' + this.loc[1] + ')  HP: ' + this.curHP + '/' + this.maxHP;
      return callback(output);
    };
    return Mob;
  })();
}).call(this);
