cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'

# Models
mapModel = require '../models/map-model.js'

exports.Map = class Map
  constructor: (name) ->
    name = name.toLowerCase() # In case someone throws in some weird name
    console.log 'Loading map: ' + name
    toLoad = (require '../data/maps/' + name + '.js').map
    console.log toLoad
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this map
    @id = toLoad.id
    @name = toLoad.name
    @theme = toLoad.theme
    @mobs = toLoad.mobs
    @size = toLoad.size
  
  
  toString: (callback) ->
    output = 'MAP ' + @uid + ' [' + @name + ']  Size: ' + @size
    callback output