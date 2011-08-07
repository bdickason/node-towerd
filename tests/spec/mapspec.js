(function() {
  /* Maps Tests */  var Map, MapModel, Obj, basedir;
  basedir = '../../';
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
      this.size = 10;
      this.fakeMob = new Obj;
      this.fakeMob.symbol = 'm';
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
    it('Loads a mob when world calls a load event', function() {
      var self;
      world.emit('load', 'mob', this.fakeMob);
      this.fakeMob.emit('spawn', [0, 1]);
      self = this;
      return this.map.grid.get([0, 1], function(res) {
        return expect(res).toEqual(self.fakeMob.symbol);
      });
    });
    return it('Saves itself to the DB once loaded', function() {
      var self;
      self = this;
      return MapModel.find({
        id: this.id
      }, function(err, res) {
        return expect(res[0].name).toEqual(self.name);
      });
    });
  });
  /*
      expect(@grid).toBeDefined()
      expect(@grid.h).toEqual(@size)
      expect(@grid.w).toEqual(@size)
    it 'Populates with 0s', ->
      @grid.get [1,1], (res) ->
        expect(res).toEqual(0)
    it 'Converts to JSON', ->
      self = @  # Hack for js closures
      @grid.toJSON (res) ->
        expect(res.grid).toBeDefined()
        expect(res.grid.length).toEqual(11)    # Check first dimension
        expect(res.grid[0].length).toEqual(11) # Check second dimension
        expect(res.h).toEqual(self.size)
        expect(res.w).toEqual(self.size)  
    it 'Converts to a String', ->
      self = @
      @grid.toString (res) ->
        expect(res).toBeDefined()
        expect(res).toEqual('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
    it 'Sets 1,1 to a monster', ->
      @grid.set [1,1], 'm', ->
      @grid.get [1, 1], (res) ->
        expect(res).toEqual('m')
  
  */
}).call(this);
