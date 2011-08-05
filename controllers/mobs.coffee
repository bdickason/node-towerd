cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'

# Models
Mob = require '../models/mob-model.js'

exports.Mobs = class Mobs
  constructor: (name) ->
    console.log 'Loading mob: ' + name
    toLoad = (require '../data/mobs/' + name + '.js').mob
    console.log toLoad
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this mob
    @id = toLoad.id
    @name = toLoad.name
    @class = toLoad.class
    @speed = toLoad.speed
    @maxHP = toLoad.maxHP

  spawn: (X, Y, callback) ->
    console.log 'Spawning mob [' + @id + '] at (' + X + ',' + Y + ') with UID: ' + @uid
    @X = X
    @Y = Y
    @curHP = @maxHP # Always spawn with full life (for now!)
  
  move: (X, Y, callback) ->
    @X = @X + X
    @Y = @Y + Y
    
    console.log 'mob [' + @id + '] moved to (' + X + ',' + Y + ')'