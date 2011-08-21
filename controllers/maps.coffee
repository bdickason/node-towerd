cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
EventEmitter = (require 'events').EventEmitter
Graph = (require 'astar').Graph

# Models
mapModel = require '../models/map-model.js'

exports.Map = class Map extends EventEmitter
  constructor: (name) ->
    @type = 'map' # So other objects know I'm a map
    
    name = name.toLowerCase() # In case someone throws in some weird name
    logger.info 'Loading map: ' + name
    toLoad = (require '../data/maps/' + name + '.js').map
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this map
    { id: @id, name: @name, theme: @theme, mobs: @mobs, size: @size, active: @active, end_x: @end_x, end_y: @end_y } = toLoad

    @graph = new Graph @size

    
    @save ->
    
    @emit 'load' # Done loading, tell everyone else to react
    
    ### Event Emitters ###
    world.on 'spawn', (obj) =>
      switch obj.type
        when 'tower' 
          # Right now we only care about where the towers are on the map, nothing else blocks.
          @graph.set obj.x, obj.y, (callback) ->
    
    world.on 'move', (obj, old_x, old_y) =>
      # Update map when objects move
      # @grid.set old_x, old_y, 0, (callback) =>
      # @grid.set obj.x, obj.y, obj.symbol, (callback) ->
      # Graph - don't need to track mob movement atm.
  
  get: (x, y, callback) ->
    callback @graph.nodes[x][y].type

  save: (callback) ->
    # Save to DB
    newmap = new mapModel ( { uid: @uid, id: @id, name: @name, theme: @theme, mobs: @mobs, size: @size } )
    newmap.save (err, saved) ->
      if err
        logger.warn 'Error saving: ' + err
    
  showString: (callback) ->
    output = 'MAP ' + @uid + ' [' + @name + ']  Size: ' + @size
    callback output
  
  getPath: (x, y, end_x, end_y, callback) -> 
    @graph.path x, y, end_x, end_y, (path) ->
       callback path
