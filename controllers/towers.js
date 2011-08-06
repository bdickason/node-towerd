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
      var toLoad;
      name = name.toLowerCase();
      console.log('Loading tower: ' + name);
      toLoad = (require('../data/towers/' + name + '.js')).tower;
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id;
      this.name = toLoad.name;
      this.damage = toLoad.damage;
      this.range = toLoad.range;
      this.type = toLoad.type;
      this.loc = [null, null];
      this.model = null;
    }
    Tower.prototype.spawn = function(X, Y, callback) {
      this.loc = [X, Y];
      this.emit('spawn');
      return console.log('Spawning tower [' + this.name + '] at (' + X + ',' + Y + ') with UID: ' + this.uid);
    };
    Tower.prototype.checkTargets = function(callback) {
      return mobModel.find({
        loc: {
          $near: this.loc,
          $maxDistance: this.range
        }
      }, function(err, hits) {
        if (err) {
          return console.log('Error: ' + err);
        } else {
          this.emit('shot');
          return callback(hits);
        }
      });
    };
    Tower.prototype.save = function(callback) {
      this.model = new towerModel({
        uid: this.uid,
        id: this.id,
        name: this.name,
        damage: this.damage,
        range: this.range,
        type: this.type,
        loc: this.loc
      });
      return this.model.save(function(err, saved) {
        if (err) {
          return console.log('Error saving: ' + err);
        } else {
          return console.log('Saved Tower: ' + this.model.uid);
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
