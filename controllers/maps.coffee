cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'

# Models
Map = require '../models/map-model.js'

exports.Maps = class Maps
  constructor: (name) ->
    console.log 'Loading map: ' + name
    toLoad = (require '../data/maps/' + name + '.js').map
    console.log toLoad
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this map
    @id = toLoad.id
    @name = toLoad.name
    @theme = toLoad.theme
    @mobs = toLoad.mobs
    @size = toLoad.size
  
  