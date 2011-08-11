### Mob Tests ###
basedir = '../../'
App = require basedir + 'app.js'
Mob = (require basedir + 'controllers/mobs.js').Mob
MobModel = require basedir + 'models/mob-model.js'

Obj = (require basedir + 'controllers/utils/object.js').Obj



# Unit Tests
describe 'Mob mobs.js', ->
  beforeEach ->
    global.world = new Obj # Required because maps relies on 'world' for some events
    
    # Stub data
    @name = 'Warrior'
    @id = 'warrior'
    @active = 1
    @class = 'warrior'
    @symbol = 'W'
    @speed = 1
    @maxHP = 50

    @mob = new Mob @id

  it 'Loads a new mob called Warrior', ->
    expect(@mob.id).toEqual(@id)
    expect(@mob.name).toEqual(@name)
    expect(@mob.active).toEqual(@active)
    expect(@mob.class).toEqual(@class)
    expect(@mob.symbol).toEqual(@symbol)
    expect(@mob.speed).toEqual(@speed)  
    expect(@mob.maxHP).toEqual(@maxHP)    
  
  it 'Saves itself to the DB once loaded', ->
    self = @
    MobModel.find { id: @id }, (err, res) ->
      expect(res[0].name).toEqual self.name
  
  it 'Spawns itself on the map at 2, 3', ->
    self = @
    @mob.on 'spawn', (type, loc, callback) ->
      expect(self.mob.loc).toEqual([2, 3])
    @mob.spawn [2, 3], (callback) ->
  
  it 'Takes damage when hit', ->
    self = @
    @mob.on 'hit', (curHP, callback) ->
      expect(self.mob.curHP).toEqual(47)
    @mob.hit 3, (callback) ->
  
  it 'Dies when its HP drops to 0', ->
    self = @
    @mob.on 'die', (curHP, callback) ->
      expect(self.mob.curHP).toBeLessThan(1)
    @mob.hit 50, (callback) ->
  
  it 'Moves across the map', ->
    self = @
    
    @mob.spawn [0, 0], (callback) ->
    
    @mob.on 'move', (type, oldLoc, newLoc) ->
      expect(oldLoc).toEqual [0, 0]
      expect(newLoc).toEqual [1, 1]
    
    @mob.move 1, 1