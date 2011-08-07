(function() {
  /* Maps Tests */  var Map, Obj, basedir;
  basedir = '../../';
  Map = (require(basedir + 'controllers/maps.js')).Map;
  Obj = (require(basedir + 'controllers/utils/object.js')).Obj;
  describe('Map map.js', function() {
    beforeEach(function() {
      global.world = new Obj;
      this.mapName = 'hiddenvalley';
      this.map = new Map(this.mapName);
      return this.id = 'hiddenvalley';
    });
    return it('Loads a new map called hiddenvalley', function() {
      return expect(this.map.id).toEqual(this.id);
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
