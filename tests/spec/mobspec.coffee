### Mob Tests ###
basedir = '../../'
App = require basedir + 'app.js'
Mob = (require basedir + 'controllers/mobs.js').Mob
MobModel = require basedir + 'models/mob-model.js'

Obj = (require basedir + 'controllers/utils/object.js').Obj



# Unit Tests
describe 'Mob mobs.js', ->
  beforeEach ->
    @world = new Obj # Required because maps relies on 'world' for some events
    
    # Stub data
    @name = 'Warrior'
    @id = 'warrior'
    @active = 1
    @class = 'warrior'
    @symbol = '%'
    @speed = 1
    @maxHP = 50

    @mob = new Mob @id, @world

  it 'Loads a new mob called Warrior', ->
    expect(@mob.id).toEqual(@id)
    expect(@mob.name).toEqual(@name)
    expect(@mob.active).toEqual(@active)
    expect(@mob.class).toEqual(@class)
    expect(@mob.symbol).toEqual(@symbol)
    expect(@mob.speed).toEqual(@speed)  
    expect(@mob.maxHP).toEqual(@maxHP)    
  
  it 'Saves itself to the DB once loaded', ->
    MobModel.find { id: @id }, (err, res) =>
      expect(res[0].name).toEqual @name
  
  it 'Spawns itself on the map at 2, 3', ->
    @mob.on 'spawn', (type, x, y, callback) =>
      expect(@mob.x).toEqual(2)
      expect(@mob.y).toEqual(3)
    @mob.spawn 2, 3, (callback) ->
  
  it 'Takes damage when hit', ->
    @mob.on 'hit', (callback) =>
      expect(@mob.curHP).toEqual(47)
    @mob.hit 3, (callback) ->

  it 'Takes damage when a tower fires', ->
    @mob.on 'hit', (callback) =>
      expect(@mob.curHP).toEqual(49)
    
    @fakeTower = { type: 'tower', damage: 1 }
    @fakeTarget = { uid: @mob.uid }
    
    @world.emit 'fire', @fakeTower, @fakeTarget
    
  it 'Dies when its HP drops to 0', ->
    @mob.on 'die', (curHP, callback) =>
      expect(@mob.curHP).toBeLessThan(1)
    @mob.hit 50, (callback) ->
  
  it 'Moves across the map', ->
    ### Not working atm
    @mob.spawn [0, 0], (callback) ->
    
    @mob.on 'move', (oldLoc) ->
      expect(oldLoc).toEqual [0, 0]
      expect(newLoc).toEqual [1, 1]
    
    @mob.move 1, 1
    ###
  
