### World - Runs the game world like a pro! ###

EventEmitter = (require 'events').EventEmitter

cfg = require './config/config.js'    # contains API keys, etc.

# Init Controllers
Map = (require './controllers/maps').Map  # Map functions like render, etc.
Mob = (require './controllers/mobs').Mob  # Mob functions like move, etc.
Tower = (require './controllers/towers').Tower  # Tower functions like attack, etc.

# Initialize a new game
# Called when the player first starts or elects to restart

exports.World = class World extends EventEmitter

  constructor: (app) ->
    ### Initial config ###
    @gameTime = cfg.GAMETIMER  # every n ms, the game progresses

    # For some reason we have to wait to load everything or else 'world' doesn't get defined as a global var
    @load = setTimeout =>
      @loadEntities( { map: 'hiddenvalley' } )
    , 1000

  ### Start the game!! ###
  start: ->
    @game = setInterval =>
      @gameLoop()
    , @gameTime
    for mob in @mobs
      # Hack to start mobs walking
      mob.dx = 1
      mob.dy = 1
  
  pause: ->
    clearTimeout @game
  
  loadEntities: (json, callback) ->
    
    ### Load the map ###
    # First level: Hidden Valley
    @maps = []
    @maps.push new Map json.map
    for map in @maps
      @loadobj map 

    ### Load and spawn the towers ###
    # First map has one tower: Cannon
    @towers = []
    @towers.push new Tower 'cannon'
    @loadobj tower for tower in @towers
        
    ### Load the mobs ###
    # Each map can have many mobs
    @mobs = []
    for map in @maps
      for mobId in map.mobs
        mob = new Mob mobId
        @mobs.push mob
        @loadobj mob

    # They exist in memory but need to be spawned
    @mobs[0].spawn 0, 1, 0, 0
    @mobs[1].spawn 1, 1, 0, 0
    @towers[0].spawn 4, 4

  # Add a new object to the game (usually done by a client)
  add: (type, x, y) ->
    switch type
      when 'tower'
        tower = new Tower 'cannon'
        @towers.push tower
        @loadobj tower
        @towers[@towers.length-1].spawn x, y
  
  loadobj: (obj) ->
    # proxies 'load' events from objects
    @emit 'load', obj
    
    ### Event Emitters - set them up! ###
    obj.on 'spawn', =>
      @spawnobj obj
    obj.on 'move', (old_x, old_y) =>
      @moveobj obj, old_x, old_y
    obj.on 'fire', (target) =>
      @fireobj obj, target
  
  ### Event functions ###
  spawnobj: (obj) ->
    @emit 'spawn', obj
    
  moveobj: (obj, old_x, old_y) ->
    # Check if mob is visible before sending move
    if @maps[0].graph.isInGraph obj.x, obj.y
      @emit 'move', obj, old_x, old_y
    
  
  fireobj: (obj, target) ->
    @emit 'fire', obj, target
           
  gameLoop: ->
    # One iteration of a game loop
    # Runs every '@gameTime' seconds
    @emit 'gameLoop'  # A bunch of stuff listens to this to know when a 'turn' has finished    

    @toString (json) ->
      console.log json  # Have to log via console because of this lame array.

  getGameData: (callback) ->
    # Returns a snapshot of the current game so client can load everything
    data = { 
      cfg: cfg.TILESIZE,
      map: @maps[0],  # A user can only see the current map
      mobs: @mobs,
      towers: @towers
    }
    
    callback data
    
  destroy: ->
    logger.info 'DESTROYING the game ;('
    clearInterval @game # stop game clock
    maps = []
    mobs = []
    towers = []
  
  
  # Output current game status
  toString: (callback) ->
    callback @maps[0].graph.toString()
  