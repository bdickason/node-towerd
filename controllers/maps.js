(function() {
  var Map, cfg, mapModel, redis;
  cfg = require('../config/config.js');
  redis = require('redis');
  mapModel = require('../models/map-model.js');
  exports.Map = Map = (function() {
    function Map(name) {
      var toLoad;
      name = name.toLowerCase();
      console.log('Loading map: ' + name);
      toLoad = (require('../data/maps/' + name + '.js')).map;
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id;
      this.name = toLoad.name;
      this.theme = toLoad.theme;
      this.mobs = toLoad.mobs;
      this.size = toLoad.size;
    }
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
          return console.log('Error saving: ' + err);
        } else {
          return console.log('Saved Map: ' + newmap.uid);
        }
      });
    };
    Map.prototype.toString = function(callback) {
      var output;
      output = 'MAP ' + this.uid + ' [' + this.name + ']  Size: ' + this.size;
      return callback(output);
    };
    return Map;
  })();
}).call(this);
