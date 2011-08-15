(function() {
  var EventEmitter, Mob, cfg, mobModel, redis;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  cfg = require('../config/config.js');
  redis = require('redis');
  EventEmitter = (require('events')).EventEmitter;
  mobModel = require('../models/mob-model.js');
  exports.Mob = Mob = (function() {
    __extends(Mob, EventEmitter);
    function Mob(name) {
      var toLoad, _ref;
      this.type = 'mob';
      name = name.toLowerCase();
      logger.info('Loading mob: ' + name);
      toLoad = (require('../data/mobs/' + name + '.js')).mob;
      this.uid = Math.floor(Math.random() * 10000000);
      this.loc = [null, null];
      _ref = 0, this.dx = _ref.dx, this.dy = _ref.dy;
      this.id = toLoad.id, this.name = toLoad.name, this["class"] = toLoad["class"], this.active = toLoad.active, this.speed = toLoad.speed, this.maxHP = toLoad.maxHP, this.curHP = toLoad.curHP, this.symbol = toLoad.symbol;
      this.emit('load');
      /* Event Emitters */
      world.on('gameLoop', __bind(function() {
        return this.move(this.dx, this.dy, this.speed, function(json) {});
      }, this));
      world.on('fire', __bind(function(obj, target) {
        if (obj.type === 'tower') {
          if (this.uid === target.uid.valueOf()) {
            return this.hit(obj.damage);
          }
        }
      }, this));
    }
    Mob.prototype.spawn = function(loc, dx, dy, callback) {
      var _ref;
      this.curHP = this.maxHP;
      _ref = {
        loc: loc,
        dx: dx,
        dy: dy
      }, this.loc = _ref.loc, this.dx = _ref.dx, this.dy = _ref.dy;
      this.emit('spawn');
      logger.info('Spawning mob [' + this.id + '] at (' + this.loc + ') with UID: ' + this.uid);
      return this.save(function() {});
    };
    Mob.prototype.hit = function(damage) {
      this.curHP = this.curHP - damage;
      if (this.curHP > 0) {
        logger.info("MOB " + this.uid + " [" + this.curHP + "/" + this.maxHP + "] was hit for " + damage);
        return this.emit('hit');
      } else {
        logger.info("MOB [" + this.uid + "] is dead!");
        return this.emit('die');
      }
    };
    Mob.prototype.move = function(dx, dy, speed, callback) {
      var newloc, oldloc;
      oldloc = this.loc;
      this.loc = [(this.loc[0] + dx) * speed, (this.loc[1] + dy) * speed];
      newloc = this.loc;
      if (oldloc !== newloc) {
        return mobModel.find({
          uid: this.uid
        }, __bind(function(err, mob) {
          if (err) {
            return logger.error('Error finding mob: {@uid} ' + err);
          } else {
            mob[0].loc = newloc;
            return mob[0].save(__bind(function(err) {
              if (err) {
                return logger.warn('Error saving mob: {@uid} ' + err);
              } else {
                this.emit('move', oldloc);
                return logger.info('MOB ' + this.uid + ' [' + this.id + '] moved to (' + this.loc[0] + ',' + this.loc[1] + ')');
              }
            }, this));
          }
        }, this));
      }
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
    Mob.prototype.showString = function(callback) {
      var output;
      output = 'MOB ' + this.uid + ' [' + this.id + ']  loc: (' + this.loc[0] + ', ' + this.loc[1] + ')  HP: ' + this.curHP + '/' + this.maxHP;
      return callback(output);
    };
    return Mob;
  })();
}).call(this);
