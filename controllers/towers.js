(function() {
  var EventEmitter, Tower, cfg, mobModel, redis, towerModel;
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
  towerModel = require('../models/tower-model.js');
  mobModel = require('../models/mob-model.js');
  exports.Tower = Tower = (function() {
    __extends(Tower, EventEmitter);
    function Tower(name) {
      var self, toLoad;
      name = name.toLowerCase();
      logger.info('Loading tower: ' + name);
      toLoad = (require('../data/towers/' + name + '.js')).tower;
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id;
      this.name = toLoad.name;
      this.active = toLoad.active;
      this.damage = toLoad.damage;
      this.range = toLoad.range;
      this.symbol = toLoad.symbol;
      this.type = toLoad.type;
      this.loc = [null, null];
      this.model = null;
      self = this;
      /* Events */
      world.on('load', function(type, obj) {
        if (type === 'mob') {
          obj.on('move', function(loc) {
            return self.checkTarget(obj, function(res) {});
          });
          return obj.on('die', function(hp) {});
        }
      });
    }
    Tower.prototype.spawn = function(loc, callback) {
      this.loc = loc;
      this.emit('spawn', 'tower', this.loc);
      logger.info('Spawning tower [' + this.name + '] at (' + this.loc + ') with UID: ' + this.uid);
      return this.save(function() {});
    };
    Tower.prototype.checkTarget = function(obj, callback) {
      var self;
      self = this;
      return mobModel.find({
        loc: {
          $near: this.loc,
          $maxDistance: this.range
        }
      }, function(err, hits) {
        var mob, _i, _len;
        if (err) {
          return logger.error('Error: ' + err);
        } else {
          for (_i = 0, _len = hits.length; _i < _len; _i++) {
            mob = hits[_i];
            if (obj.loc.join('') === mob.loc.join('')) {
              self.emit('fire', mob.uid.valueOf(), self.damage);
            }
          }
          return callback(hits);
        }
      });
    };
    Tower.prototype.save = function(callback) {
      var self;
      this.model = new towerModel({
        uid: this.uid,
        id: this.id,
        name: this.name,
        damage: this.damage,
        range: this.range,
        type: this.type,
        loc: this.loc
      });
      self = this;
      return this.model.save(function(err, saved) {
        if (err) {
          return logger.warn('Error saving: ' + err);
        }
      });
    };
    Tower.prototype.toString = function(callback) {
      var output;
      output = 'TOWER ' + this.uid + ' [' + this.id + ']  loc: (' + this.loc[0] + ', ' + this.loc[1] + ')  Range: ' + this.range;
      return callback(output);
    };
    return Tower;
  })();
}).call(this);
