cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'

# Models
mapModel = require '../models/map-model.js'

exports.Tower = class Tower
  constructor: (name) ->
    name = name.toLowerCase() # In case someone throws in some weird name
    console.log 'Loading tower: ' + name
    toLoad = (require '../data/towers/' + name + '.js').tower
    console.log toLoad
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this tower
    @id = toLoad.id         # Machine readable version
    @name = toLoad.name     # Human readable version
    @damage = toLoad.damage
    @range = toLoad.range
    @type = toLoad.type     # e.g. cannon, arrow, etc.
    @loc =
      X: null # Hasn't been spawned yet, so position is null
      Y: null

  # Activate the tower and place it on the map
  spawn: (X, Y, callback) ->
    @loc.X = X
    @loc.Y = Y
    console.log 'Spawning tower [' + @name + '] at (' + X + ',' + Y + ') with UID: ' + @uid
  
  # Check for anything within range
  checkTargets: (callback) ->
    
    
  toString: (callback) ->
    output = 'TOWER ' + @uid + ' [' + @id + ']  loc: (' + @loc.X + ', ' + @loc.Y + ')  Range: ' + @range
    callback output