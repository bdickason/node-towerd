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
    world = new Obj # Required because maps relies on 'world' for some events
    
    # Stub data
    @name = 'Hidden Valley'
    @id = 'hiddenvalley'
    @active = 100
    @theme = 'Forest'
    @mobs = [ 'warrior', 'warrior' ]
    @size = 12

    @fakeMob = new Obj   # Load a fake mob to emit events
    @fakeMob.type = 'mob'
    @fakeMob.symbol = 'm'
    @fakeMob.x = 0
    @fakeMob.y = 1
    
    @map = new Map @id, world

  it 'Loads a new map called hiddenvalley', ->
    expect(@map.id).toEqual(@id)
    expect(@map.name).toEqual(@name)
    expect(@map.active).toEqual(@active)
    expect(@map.theme).toEqual(@theme)
    expect(@map.mobs).toEqual(@mobs)
    expect(@map.size).toEqual(@size)

  it 'Saves itself to the DB once loaded', ->
    MapModel.find { id: @id }, (err, res) =>
      expect(res[0].name).toEqual @name