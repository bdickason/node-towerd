(function() {
  /* Maps Tests */  var Map, MapModel, Obj, basedir;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  basedir = '../../';
  global.db = require(basedir + 'models/db').db;
  Map = (require(basedir + 'controllers/maps.js')).Map;
  MapModel = require(basedir + 'models/map-model.js');
  Obj = (require(basedir + 'controllers/utils/object.js')).Obj;
  describe('Map map.js', function() {
    beforeEach(function() {
      var world;
      world = new Obj;
      this.name = 'Hidden Valley';
      this.id = 'hiddenvalley';
      this.active = 1;
      this.theme = 'Forest';
      this.mobs = ['warrior', 'warrior'];
      this.size = 12;
      this.fakeMob = new Obj;
      this.fakeMob.type = 'mob';
      this.fakeMob.symbol = 'm';
      this.fakeMob.x = 0;
      this.fakeMob.y = 1;
      return this.map = new Map(this.id, world);
    });
    it('Loads a new map called hiddenvalley', function() {
      expect(this.map.id).toEqual(this.id);
      expect(this.map.name).toEqual(this.name);
      expect(this.map.active).toEqual(this.active);
      expect(this.map.theme).toEqual(this.theme);
      expect(this.map.mobs).toEqual(this.mobs);
      return expect(this.map.size).toEqual(this.size);
    });
    return it('Saves itself to the DB once loaded', function() {
      return MapModel.find({
        id: this.id
      }, __bind(function(err, res) {
        return expect(res[0].name).toEqual(this.name);
      }, this));
    });
  });
}).call(this);
