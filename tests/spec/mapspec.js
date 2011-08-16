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
      global.world = new Obj;
      this.name = 'Hidden Valley';
      this.id = 'hiddenvalley';
      this.active = 1;
      this.theme = 'Forest';
      this.mobs = ['warrior', 'warrior'];
      this.size = 15;
      this.fakeMob = new Obj;
      this.fakeMob.type = 'mob';
      this.fakeMob.symbol = 'm';
      this.fakeMob.x = 0;
      this.fakeMob.y = 1;
      return this.map = new Map(this.id);
    });
    it('Loads a new map called hiddenvalley', function() {
      expect(this.map.id).toEqual(this.id);
      expect(this.map.name).toEqual(this.name);
      expect(this.map.active).toEqual(this.active);
      expect(this.map.theme).toEqual(this.theme);
      expect(this.map.mobs).toEqual(this.mobs);
      return expect(this.map.size).toEqual(this.size);
    });
    it('Loads a mob onto the map when world calls a spawn event', function() {
      world.emit('spawn', this.fakeMob);
      return this.map.grid.get(0, 1, __bind(function(res) {
        return expect(res).toEqual(this.fakeMob.symbol);
      }, this));
    });
    it('Doesn\'t display mobs that are spawned outside the map', function() {
      this.fakeMob.x = 10;
      this.fakeMob.y = 20;
      world.emit('spawn', this.fakeMob);
      return this.map.grid.get(10, 20, __bind(function(res) {
        expect(this.fakeMob.x).toEqual(10);
        expect(this.fakeMob.y).toEqual(20);
        return expect(res).toBeUndefined();
      }, this));
    });
    it('Updates a mob\'s position as it moves across the map', function() {
      var old_x, old_y;
      world.emit('spawn', this.fakeMob);
      this.map.grid.get(0, 1, __bind(function(res) {
        return expect(res).toEqual(this.fakeMob.symbol);
      }, this));
      old_x = this.fakeMob.x;
      old_y = this.fakeMob.y;
      this.fakeMob.x = 5;
      this.fakeMob.y = 6;
      world.emit('move', this.fakeMob, old_x, old_y);
      this.map.grid.get(old_x, old_y, __bind(function(res) {
        return expect(res).toEqual(0);
      }, this));
      return this.map.grid.get(5, 6, __bind(function(res) {
        return expect(res).toEqual(this.fakeMob.symbol);
      }, this));
    });
    it('Ignores mobs that move outside of the map', function() {
      var old_x, old_y;
      world.emit('spawn', this.fakeMob);
      this.map.grid.get(0, 1, __bind(function(res) {
        return expect(res).toEqual(this.fakeMob.symbol);
      }, this));
      old_x = this.fakeMob.x;
      old_y = this.fakeMob.y;
      this.fakeMob.x = 25;
      this.fakeMob.y = 6;
      world.emit('move', this.fakeMob, old_x, old_y);
      this.map.grid.get(5, 6, __bind(function(res) {
        return expect(res).toEqual(0);
      }, this));
      return this.map.grid.get(25, 6, __bind(function(res) {
        expect(this.fakeMob.x).toEqual(25);
        expect(this.fakeMob.y).toEqual(6);
        return expect(res).toBeUndefined();
      }, this));
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
