### Maps Tests ###
basedir = '../../'
Map = (require basedir + 'controllers/maps.js').Map
Obj = (require basedir + 'controllers/utils/object.js').Obj


# Unit Tests
describe 'Map map.js', ->
  beforeEach ->
    # Stub data
    global.world = new Obj # Required because maps relies on 'world' for some events
    @mapName = 'hiddenvalley'
    @map = new Map @mapName
    @id = 'hiddenvalley'
    

  it 'Loads a new map called hiddenvalley', ->
    expect(@map.id).toEqual(@id)
    
    

###
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

###      
# Integration Tests

