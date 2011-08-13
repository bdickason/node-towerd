### Maps Tests ###
basedir = '../../'

# Initialize DB
global.db = require(basedir + 'models/db').db

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
    @fakeMob.type = 'mob'
    @fakeMob.symbol = 'm'
    @fakeMob.loc = [0, 1]
    
    @map = new Map @id

  it 'Loads a new map called hiddenvalley', ->
    expect(@map.id).toEqual(@id)
    expect(@map.name).toEqual(@name)
    expect(@map.active).toEqual(@active)
    expect(@map.theme).toEqual(@theme)
    expect(@map.mobs).toEqual(@mobs)
    expect(@map.size).toEqual(@size)

  it 'Loads a mob onto the map when world calls a spawn event', ->
    world.emit 'spawn', @fakeMob

    @map.grid.get [0, 1], (res) =>
      expect(res).toEqual(@fakeMob.symbol)
  
  it 'Doesn\'t display mobs that are spawned outside the map', ->
    @fakeMob.loc = [10, 15]
    world.emit 'spawn', @fakeMob
    
    @map.grid.get [10, 15], (res) =>
      expect(@fakeMob.loc).toEqual([10, 15])
      expect(res).toBeUndefined()

  it 'Updates a mob\'s position as it moves across the map', ->
    world.emit 'spawn', @fakeMob

    @map.grid.get [0, 1], (res) =>
      expect(res).toEqual(@fakeMob.symbol)
    
    oldloc = @fakeMob.loc
    
    @fakeMob.loc = [5, 6]
    world.emit 'move', @fakeMob, oldloc
    
    @map.grid.get oldloc, (res) =>
      expect(res).toEqual(0)
    
    @map.grid.get [5, 6], (res) =>
      expect(res).toEqual(@fakeMob.symbol)
  
  it 'Ignores mobs that move outside of the map', ->
    world.emit 'spawn', @fakeMob
    
    @map.grid.get [0, 1], (res) =>
      expect(res).toEqual(@fakeMob.symbol)
  
    oldloc = @fakeMob.loc
    @fakeMob.loc = [11, 6]
    world.emit 'move', @fakeMob, oldloc
  
    @map.grid.get [5, 6], (res) =>
      expect(res).toEqual(0)
    
    @map.grid.get [11, 6], (res) =>
      expect(@fakeMob.loc).toEqual([11, 6])
      expect(res).toBeUndefined()

  it 'Saves itself to the DB once loaded', ->
    MapModel.find { id: @id }, (err, res) =>
      expect(res[0].name).toEqual @name