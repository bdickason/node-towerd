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

  it 'Loads a mob when world calls a load event', ->
    world.emit 'load', 'mob', @fakeMob  # called when a mob is loaded
    @fakeMob.emit 'spawn', 'mob', [0, 1]       # called when a mob is spawned
    self = @
  
    @map.grid.get [0, 1], (res) ->
      expect(res).toEqual(self.fakeMob.symbol)
  
  it 'Saves itself to the DB once loaded', ->
    self = @
    MapModel.find { id: @id }, (err, res) ->
      expect(res[0].name).toEqual self.name