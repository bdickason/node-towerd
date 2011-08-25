(function() {
  var EventEmitter, Tower, cfg, mobModel, redis, towerModel;
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
  towerModel = require('../models/tower-model.js');
  mobModel = require('../models/mob-model.js');
  exports.Tower = Tower = (function() {
    __extends(Tower, EventEmitter);
    function Tower(name, world) {
      var toLoad;
      this.type = 'tower';
      name = name.toLowerCase();
      logger.info('Loading tower: ' + name);
      toLoad = (require('../data/towers/' + name + '.js')).tower;
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id, this.name = toLoad.name, this.active = toLoad.active, this.damage = toLoad.damage, this.range = toLoad.range, this.symbol = toLoad.symbol;
      this.x = null;
      this.y = null;
      this.model = null;
      this.emit('load');
      /* Events */
      world.on('move', __bind(function(obj) {
        if (obj.type === 'mob') {
          return this.checkTarget(obj, function(res) {});
        }
      }, this));
    }
    Tower.prototype.spawn = function(x, y, callback) {
      this.x = x;
      this.y = y;
      this.emit('spawn');
      logger.info('Spawning tower [' + this.name + '] at (' + this.x + ', ' + this.y + ') with UID: ' + this.uid);
      return this.save(function() {});
    };
    Tower.prototype.checkTarget = function(obj, callback) {
      if (obj.x >= (this.x - this.range) && obj.x <= (this.x + this.range) && obj.y >= (this.y - this.range) && obj.y <= (this.y + this.range)) {
        this.emit('fire', obj);
        return callback(obj);
      }
    };
    Tower.prototype.save = function(callback) {
      this.model = new towerModel({
        uid: this.uid,
        id: this.id,
        name: this.name,
        damage: this.damage,
        range: this.range,
        type: this.type,
        x: this.x,
        y: this.y
      });
      return this.model.save(function(err, saved) {
        if (err) {
          return logger.warn('Error saving: ' + err);
        }
      });
    };
    Tower.prototype.showString = function(callback) {
      var output;
      output = 'TOWER ' + this.uid + ' [' + this.id + ']  loc: (' + this.x + ', ' + this.y + ')  Range: ' + this.range;
      return callback(output);
    };
    return Tower;
  })();
}).call(this);
