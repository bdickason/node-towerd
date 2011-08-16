cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
EventEmitter = (require 'events').EventEmitter

# Models
towerModel = require '../models/tower-model.js'
mobModel = require '../models/mob-model.js'

exports.Tower = class Tower extends EventEmitter
  constructor: (name) ->
    @type = 'tower' # So other objects know I'm a tower    
    name = name.toLowerCase() # In case someone throws in some weird name
    logger.info 'Loading tower: ' + name
    toLoad = (require '../data/towers/' + name + '.js').tower
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this tower
    { id: @id, name: @name, active: @active, damage: @damage, range: @range, symbol: @symbol } = toLoad
    @x = null
    @y = null  # Hasn't been spawned yet, so position is null
    @model = null
    
    @emit 'load'
    
    ### Events ###
    world.on 'move', (obj) =>    
      # Ignore all other towers and maps
      if obj.type == 'mob'
          @checkTarget obj, (res) ->
      
  # Activate the tower and place it on the map
  spawn: (x, y, callback) ->
    @x = x
    @y = y
    @emit 'spawn'
    logger.info 'Spawning tower [' + @name + '] at (' + @x + ', ' + @y + ') with UID: ' + @uid
    
    @save ->

  
  # Check for anything within range
  checkTarget: (obj, callback) -> 
    # Use a simple box check to see if mob is in range after moving

    if obj.x >= (@x - @range) and obj.x <= (@x + @range) and obj.y >= (@y - @range) and obj.y <= (@y + @range)
      # Mob is a hit!
      logger.debug 'Hit! ' + obj.uid
      @emit 'fire', obj
      callback obj
      
  save: (callback) ->
    # Save to DB
    @model = new towerModel ( { uid: @uid, id: @id, name: @name, damage: @damage, range: @range, type: @type, x: @x, y: @y } )
    @model.save (err, saved) ->
      if err
        logger.warn 'Error saving: ' + err
    
  showString: (callback) ->
    output = 'TOWER ' + @uid + ' [' + @id + ']  loc: (' + @x + ', ' + @y + ')  Range: ' + @range
    callback output