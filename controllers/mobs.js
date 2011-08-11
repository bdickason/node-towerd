(function() {
  var EventEmitter, Mob, cfg, mobModel, redis;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  cfg = require('../config/config.js');
  redis = require('redis');
  EventEmitter = (require('events')).EventEmitter;
  mobModel = require('../models/mob-model.js');
  exports.Mob = Mob = (function() {
    __extends(Mob, EventEmitter);
    function Mob(name) {
      var self, toLoad;
      name = name.toLowerCase();
      logger.info('Loading mob: ' + name);
      toLoad = (require('../data/mobs/' + name + '.js')).mob;
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id;
      this.name = toLoad.name;
      this["class"] = toLoad["class"];
      this.active = toLoad.active;
      this.speed = toLoad.speed;
      this.maxHP = toLoad.maxHP;
      this.symbol = toLoad.symbol;
      this.loc = [null, null];
      this.curHP = toLoad.curHP;
      /* Event Emitters */
      self = this;
      world.on('gameLoop', function() {
        return self.move(1, 1, function(json) {});
      });
      world.on('load', function(type, obj) {
        if (type === 'tower') {
          return obj.on('fire', function(uid, damage) {
            if (self.uid === uid) {
              return self.hit(damage);
            }
          });
        }
      });
    }
    Mob.prototype.spawn = function(loc, callback) {
      this.curHP = this.maxHP;
      this.loc = loc;
      this.emit('spawn', 'mob', this.loc);
      logger.info('Spawning mob [' + this.id + '] at (' + this.loc + ') with UID: ' + this.uid);
      return this.save(function() {});
    };
    Mob.prototype.hit = function(damage) {
      this.curHP = this.curHP - damage;
      if (this.curHP > 0) {
        logger.debug("MOB " + this.uid + " [" + this.curHP + "/" + this.maxHP + "] was hit for " + damage);
        return this.emit('hit', this.curHP);
      } else {
        logger.info("MOB [" + this.uid + "] is dead!");
        return this.emit('die', this.curHP);
      }
    };
    Mob.prototype.move = function(X, Y, callback) {
      var newloc, oldloc, self;
      oldloc = this.loc;
      this.loc = [this.loc[0] + X, this.loc[1] + Y];
      newloc = this.loc;
      self = this;
      return mobModel.find({
        uid: this.uid
      }, function(err, mob) {
        if (err) {
          return logger.error('Error finding mob: {@uid} ' + err);
        } else {
          mob[0].loc = newloc;
          return mob[0].save(function(err) {
            if (err) {
              return logger.warn('Error saving mob: {@uid} ' + err);
            } else {
              self.emit('move', 'mob', oldloc, newloc);
              return logger.info('MOB ' + self.uid + ' [' + self.id + '] moved to (' + self.loc[0] + ',' + self.loc[1] + ')');
            }
          });
        }
      });
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
          return logger.error('Error saving: ' + err);
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
