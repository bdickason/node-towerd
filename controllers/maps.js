(function() {
  var EventEmitter, Graph, Map, cfg, mapModel, redis;
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
  Graph = (require('astar')).Graph;
  mapModel = require('../models/map-model.js');
  exports.Map = Map = (function() {
    __extends(Map, EventEmitter);
    function Map(name) {
      var toLoad;
      this.type = 'map';
      name = name.toLowerCase();
      logger.info('Loading map: ' + name);
      toLoad = (require('../data/maps/' + name + '.js')).map;
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id, this.name = toLoad.name, this.theme = toLoad.theme, this.mobs = toLoad.mobs, this.size = toLoad.size, this.active = toLoad.active, this.end_x = toLoad.end_x, this.end_y = toLoad.end_y;
      this.graph = new Graph(this.size);
      this.save(function() {});
      this.emit('load');
      /* Event Emitters */
      world.on('spawn', __bind(function(obj) {
        switch (obj.type) {
          case 'tower':
            return this.graph.set(obj.x, obj.y, function(callback) {});
        }
      }, this));
      world.on('move', __bind(function(obj, old_x, old_y) {}, this));
    }
    Map.prototype.get = function(x, y, callback) {
      return callback(this.graph.nodes[x][y].type);
    };
    Map.prototype.save = function(callback) {
      var newmap;
      newmap = new mapModel({
        uid: this.uid,
        id: this.id,
        name: this.name,
        theme: this.theme,
        mobs: this.mobs,
        size: this.size
      });
      return newmap.save(function(err, saved) {
        if (err) {
          return logger.warn('Error saving: ' + err);
        }
      });
    };
    Map.prototype.showString = function(callback) {
      var output;
      output = 'MAP ' + this.uid + ' [' + this.name + ']  Size: ' + this.size;
      return callback(output);
    };
    Map.prototype.getPath = function(x, y, end_x, end_y, callback) {
      return this.graph.path(x, y, end_x, end_y, function(path) {
        return callback(path);
      });
    };
    return Map;
  })();
}).call(this);
