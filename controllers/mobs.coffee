cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
EventEmitter = (require 'events').EventEmitter

# Models
mobModel = require '../models/mob-model.js'

exports.Mob = class Mob extends EventEmitter
  constructor: (name) ->
    name = name.toLowerCase()   # In case someone throws in some weird name
    console.log 'Loading mob: ' + name
    toLoad = (require '../data/mobs/' + name + '.js').mob
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this mob
    @id = toLoad.id
    @name = toLoad.name
    @class = toLoad.class
    @speed = toLoad.speed
    @maxHP = toLoad.maxHP
    @loc = [null, null]  # Hasn't been spawned yet, so position is null
    @curHP = null # Hasn't spawned so has no HP.
    
  spawn: (X, Y, callback) ->
    @loc = [X, Y]
    @curHP = @maxHP # Always spawn with full life (for now!)
    @emit 'spawn', 'mob', @loc
    console.log 'Spawning mob [' + @id + '] at (' + X + ',' + Y + ') with UID: ' + @uid
  
  hit: (damage) ->
    @curHP = @curHP - damage
    if @curHP > 0
      @emit 'hit'
    else
      # mob is dead!
      @emit 'die'
  
  move: (X, Y, callback) ->
    oldloc = @loc
    @loc = [@loc[0] + X, @loc[1] + Y]
    newloc = @loc
    self = @

    mobModel.find { uid: @uid }, (err, mob) ->
      if(err)
        console.log 'Error finding mob: {@uid} ' + err
      else
        mob[0].loc = newloc
        mob[0].save (err) ->
          if (err)
            console.log 'Error saving mob: {@uid} ' + err
          else
            self.emit 'move', 'mob', oldloc, newloc
    console.log 'MOB ' + @uid + ' [' + @id + '] moved to (' + @loc[0] + ',' + @loc[1] + ')'

  save: (callback) ->
    # Save to DB
    newmob = new mobModel ( { uid: @uid, id: @id, name: @name, class: @class, speed: @speed, maxHP: @maxHP, curHP: @curHP, loc: @loc } )
    newmob.save (err, saved) ->
      if err
        console.log 'Error saving: ' + err
      else
        console.log 'Saved Mob: ' + newmob.uid
    
  toString: (callback) ->
    output = 'MOB ' + @uid + ' [' + @id + ']  loc: (' + @loc[0] + ', ' + @loc[1] + ')  HP: ' + @curHP + '/' + @maxHP
    callback output