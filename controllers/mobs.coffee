cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'

# Models
mobModel = require '../models/mob-model.js'

exports.Mob = class Mob
  constructor: (name) ->
    name = name.toLowerCase()   # In case someone throws in some weird name
    console.log 'Loading mob: ' + name
    toLoad = (require '../data/mobs/' + name + '.js').mob
    console.log toLoad
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this mob
    @id = toLoad.id
    @name = toLoad.name
    @class = toLoad.class
    @speed = toLoad.speed
    @maxHP = toLoad.maxHP
    @loc =
      X: null # Hasn't been spawned yet, so position is null
      Y: null
    @curHP = null # Hasn't spawned so has no HP.

  spawn: (X, Y, callback) ->
    @loc.X = X
    @loc.Y = Y
    @curHP = @maxHP # Always spawn with full life (for now!)
    console.log 'Spawning mob [' + @id + '] at (' + X + ',' + Y + ') with UID: ' + @uid
  
  move: (X, Y, callback) ->
    @loc.X = @loc.X + X
    @loc.Y = @loc.Y + Y
    
    console.log 'MOB ' + @uid + ' [' + @id + '] moved to (' + @loc.X + ',' + @loc.Y + ')'
    
  toString: (callback) ->
    output = 'MOB ' + @uid + ' [' + @id + ']  loc: (' + @loc.X + ', ' + @loc.Y + ')  HP: ' + @curHP + '/' + @maxHP
    callback output