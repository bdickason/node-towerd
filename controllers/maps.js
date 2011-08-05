(function() {
  var Map, Maps, cfg, redis;
  cfg = require('../config/config.js');
  redis = require('redis');
  Map = require('../models/map-model.js');
  exports.Maps = Maps = (function() {
    function Maps(name) {
      var toLoad;
      console.log('Loading map: ' + name);
      toLoad = (require('../data/maps/' + name + '.js')).map;
      console.log(toLoad);
      this.uid = Math.floor(Math.random() * 10000000);
      this.id = toLoad.id;
      this.name = toLoad.name;
      this.theme = toLoad.theme;
      this.mobs = toLoad.mobs;
      this.size = toLoad.size;
    }
    return Maps;
  })();
}).call(this);
