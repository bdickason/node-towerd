cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
Grid = (require './utils/grid.js').Grid

# Models
mapModel = require '../models/map-model.js'

exports.Map = class Map
  constructor: (name) ->
    name = name.toLowerCase() # In case someone throws in some weird name
    logger.info 'Loading map: ' + name
    toLoad = (require '../data/maps/' + name + '.js').map
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this map
    @id = toLoad.id
    @name = toLoad.name
    @theme = toLoad.theme
    @mobs = toLoad.mobs
    @size = toLoad.size
    @active = toLoad.active
    @grid = new Grid @size
    
    @save ->
    
    self = @
    
    ### Event Emitters ###
    world.on 'load', (type, obj) ->
      # Ignore all map events
      if type != 'map'
        # Place objects on the map when they spawn
        obj.on 'spawn', (loc) ->
          self.grid.set obj.loc, obj.symbol, (callback) ->
        
        # Update map when objects move
        obj.on 'move', (type, oldloc, newloc) ->
          self.grid.set oldloc, 0, (callback) ->
          self.grid.set newloc, obj.symbol, (callback) ->
        
  save: (callback) ->
    # Save to DB
    newmap = new mapModel ( { uid: @uid, id: @id, name: @name, theme: @theme, mobs: @mobs, size: @size } )
    newmap.save (err, saved) ->
      if err
        logger.warn 'Error saving: ' + err
    
  toString: (callback) ->
    output = 'MAP ' + @uid + ' [' + @name + ']  Size: ' + @size
    callback output