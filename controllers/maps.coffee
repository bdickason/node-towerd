cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
EventEmitter = (require 'events').EventEmitter
Grid = (require './utils/grid.js').Grid

# Models
mapModel = require '../models/map-model.js'

exports.Map = class Map extends EventEmitter
  constructor: (name) ->
    @type = 'map' # So other objects know I'm a map
    
    name = name.toLowerCase() # In case someone throws in some weird name
    logger.info 'Loading map: ' + name
    toLoad = (require '../data/maps/' + name + '.js').map
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this map
    { id: @id, name: @name, theme: @theme, mobs: @mobs, size: @size, active: @active } = toLoad
    @grid = new Grid @size
    
    @save ->
    
    @emit 'load' # Done loading, tell everyone else to react
    
    ### Event Emitters ###
    world.on 'spawn', (obj) =>
      # Ignore all map events
      if obj.type != 'map'
        # Place objects on the map when they spawn
        @grid.set obj.loc, obj.symbol, (callback) ->
    
    world.on 'move', (obj, oldloc) =>
      # Update map when objects move
      @grid.set oldloc, 0, (callback) =>
      @grid.set obj.loc, obj.symbol, (callback) ->
        
  save: (callback) ->
    # Save to DB
    newmap = new mapModel ( { uid: @uid, id: @id, name: @name, theme: @theme, mobs: @mobs, size: @size } )
    newmap.save (err, saved) ->
      if err
        logger.warn 'Error saving: ' + err
    
  showString: (callback) ->
    output = 'MAP ' + @uid + ' [' + @name + ']  Size: ' + @size
    callback output