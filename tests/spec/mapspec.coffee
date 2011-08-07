### Maps Tests ###
basedir = '../../'
Map = (require basedir + 'controllers/maps.js').Map
MapModel = require basedir + 'models/map-model.js' 
Obj = (require basedir + 'controllers/utils/object.js').Obj


# Unit Tests
describe 'Map map.js', ->
  beforeEach ->
    global.world = new Obj # Required because maps relies on 'world' for some events
    
    # Stub data
    @name = 'Hidden Valley'
    @id = 'hiddenvalley'
    @active = 1
    @theme = 'Forest'
    @mobs = [ 'warrior', 'warrior' ]
    @size = 10

    @fakeMob = new Obj   # Load a fake mob to emit events
    @fakeMob.symbol = 'm'
    
    @map = new Map @id

  it 'Loads a new map called hiddenvalley', ->
    expect(@map.id).toEqual(@id)
    expect(@map.name).toEqual(@name)
    expect(@map.active).toEqual(@active)
    expect(@map.theme).toEqual(@theme)
    expect(@map.mobs).toEqual(@mobs)
    expect(@map.size).toEqual(@size)

  it 'Loads a mob when world calls a load event', ->
    world.emit 'load', 'mob', @fakeMob  # called when a mob is loaded
    @fakeMob.emit 'spawn', [0, 1]       # called when a mob is spawned
    self = @    
    @map.grid.get [0, 1], (res) ->
      expect(res).toEqual(self.fakeMob.symbol)
  
  it 'Saves itself to the DB once loaded', ->
    self = @
    MapModel.find { id: @id }, (err, res) ->
      expect(res[0].name).toEqual self.name

    
    

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

