cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'

# Models
towerModel = require '../models/tower-model.js'
mobModel = require '../models/mob-model.js'

exports.Tower = class Tower
  constructor: (name) ->
    name = name.toLowerCase() # In case someone throws in some weird name
    console.log 'Loading tower: ' + name
    toLoad = (require '../data/towers/' + name + '.js').tower
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this tower
    @id = toLoad.id         # Machine readable version
    @name = toLoad.name     # Human readable version
    @damage = toLoad.damage
    @range = toLoad.range
    @type = toLoad.type     # e.g. cannon, arrow, etc.
    @loc = [null, null]  # Hasn't been spawned yet, so position is null
    @model = null

  # Activate the tower and place it on the map
  spawn: (X, Y, callback) ->
    @loc = [X, Y]
    console.log 'Spawning tower [' + @name + '] at (' + X + ',' + Y + ') with UID: ' + @uid
  
  # Check for anything within range
  checkTargets: (callback) ->
    mobModel.find { loc : { $near : @loc , $maxDistance : @range } }, (err, hits) -> 
      if err
        console.log 'Error: ' + err
      else
        console.log hits
  
  save: (callback) ->
    # Save to DB
    @model = new towerModel ( { uid: @uid, id: @id, name: @name, damage: @damage, range: @range, type: @type, loc: @loc } )
    @model.save (err, saved) ->
      if err
        console.log 'Error saving: ' + err
      else
        console.log 'Saved Tower: ' + @model.uid
    
  toString: (callback) ->
    output = 'TOWER ' + @uid + ' [' + @id + ']  loc: (' + @loc[0] + ', ' + @loc[1] + ')  Range: ' + @range
    callback output