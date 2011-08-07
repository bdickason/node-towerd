cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
Grid = (require './utils/grid.js').Grid

# Models
mapModel = require '../models/map-model.js'

exports.Map = class Map
  constructor: (name) ->
    name = name.toLowerCase() # In case someone throws in some weird name
    console.log 'Loading map: ' + name
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
      if type != 'map'
        obj.on 'spawn', (loc) ->
          self.grid.set loc, obj.symbol, (callback) ->
            
      
    world.on 'move', () ->
        
  save: (callback) ->
    # Save to DB
    newmap = new mapModel ( { uid: @uid, id: @id, name: @name, theme: @theme, mobs: @mobs, size: @size } )
    newmap.save (err, saved) ->
      if err
        console.log 'Error saving: ' + err
      else
        console.log 'Saved Map: ' + newmap.uid
    
  toString: (callback) ->
    output = 'MAP ' + @uid + ' [' + @name + ']  Size: ' + @size
    callback output