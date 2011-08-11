cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
EventEmitter = (require 'events').EventEmitter

# Models
towerModel = require '../models/tower-model.js'
mobModel = require '../models/mob-model.js'

exports.Tower = class Tower extends EventEmitter
  constructor: (name) ->
    name = name.toLowerCase() # In case someone throws in some weird name
    logger.info 'Loading tower: ' + name
    toLoad = (require '../data/towers/' + name + '.js').tower
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this tower
    @id = toLoad.id         # Machine readable version
    @name = toLoad.name     # Human readable version
    @active = toLoad.active
    @damage = toLoad.damage
    @range = toLoad.range
    @symbol = toLoad.symbol
    @type = toLoad.type     # e.g. cannon, arrow, etc.
    @loc = [null, null]  # Hasn't been spawned yet, so position is null
    @model = null

    self = @
    
    ### Events ###
    world.on 'load', (type, obj) ->
      # Ignore all other towers and maps
      if type == 'mob'
        # Check targets each time a mob moves        
        obj.on 'move', (loc) ->
          self.checkTarget obj, (res) ->
        obj.on 'die', (hp) ->          
      
  # Activate the tower and place it on the map
  spawn: (loc, callback) ->
    @loc = loc
    @emit 'spawn', 'tower', @loc
    logger.info 'Spawning tower [' + @name + '] at (' + @loc + ') with UID: ' + @uid
    
    @save ->

  
  # Check for anything within range
  checkTarget: (obj, callback) -> 
    self = @
    mobModel.find { loc : { $near : @loc , $maxDistance : @range } }, (err, hits) -> 
      if err
        logger.error 'Error: ' + err
      else
        for mob in hits
          if obj.loc.join('') == mob.loc.join('') # can't compare two objects directly
            self.emit 'fire', mob.uid.valueOf(), self.damage
        callback hits
  
  save: (callback) ->
    # Save to DB
    @model = new towerModel ( { uid: @uid, id: @id, name: @name, damage: @damage, range: @range, type: @type, loc: @loc } )
    self = @
    @model.save (err, saved) ->
      if err
        logger.warn 'Error saving: ' + err
    
  toString: (callback) ->
    output = 'TOWER ' + @uid + ' [' + @id + ']  loc: (' + @loc[0] + ', ' + @loc[1] + ')  Range: ' + @range
    callback output