EventEmitter = (require 'events').EventEmitter
# TODO - rename 'map' to 'Map' etc.
map = (require './controllers/maps').Map  # Map functions like render, etc.
mob = (require './controllers/mobs').Mob  # Mob functions like move, etc.
tower = (require './controllers/towers').Tower  # Tower functions like attack, etc.

# Initialize a new game
# Called when the player first starts or elects to restart

exports.World = class World extends EventEmitter

  constructor: ->
    ### Initial config ###
    @gameTime = 3000  # every 3000ms, the game progresses

    ### Start the game!! ###
    @game = setInterval ->
      world.gameLoop()
    , @gameTime
    
    # For some reason we have to wait to load everything    
    self = @
    @load = setTimeout ->
      self.loadEntities()
    , 1000
    
      
  loadEntities: (callback) ->
    
    ### Load the map ###
    # First level: Hidden Valley
    @maps = []
    @maps.push new map 'hiddenvalley'
    @emit 'load', 'map', _map for _map in @maps

    ### Load and spawn the towers ###
    # First map has one tower: Cannon
    @towers = []
    @towers.push new tower 'cannon'
    
    for _tower in @towers
      @emit 'load', 'tower', _tower
        
    ### Load the mobs ###
    # Each map can have many mobs
    @mobs = []
    for _map in @maps
      console.log _map
      for mobId in _map.mobs
        _mob = new mob mobId
        @mobs.push _mob
        @emit 'load', 'mob', _mob
        console.log 'Spawning: ' + _mob.uid

    # They exist in memory but need to be spawned
    @mobs[0].emit 'spawn', [0, 0]
    @mobs[1].emit 'spawm', [1, 0] # Why is this guy not getting called?
    @towers[0].emit 'spawn', [4, 4]


    ### Save everything to mongo
    @maps[0].save ->    

    console.log 'TOWERS!'
    console.log @towers
    @towers[0].save ->
    
    console.log 'MOBS!'
    console.log @mobs
    
    @mobs[0].save ->
    
    console.log 'MOBS!'
    console.log @mobs
    @mobs[1].save -> ###
    
    # callback 'success!'
         
  gameLoop: ->
    # One iteration of a game loop
    # Runs every '@gameTime' seconds
    @emit 'gameLoop'
    
    # Temporary disabled while working on events
    ###for mob in @mobs
      mob.move 1, 1, (json) -> ###
    
    ###@toString (json) ->
      console.log json ###
    
  destroy: ->
    console.log 'DESTROYING the game ;('
    clearInterval @game # stop game clock
    maps = []
    mobs = []
    towers = []
  
  
  # Output current game status
  toString: (callback) ->
    callback @maps[0].grid
    
  
  ### Handle Event Emitters/Listeners ###
  handleSpawn: (type, loc, json) ->
    symbol = 0
    
    switch type
      when 'mob'
        symbol = 'm'
      when 'tower'
        symbol = 'T'

    if @maps.length      
      for _map in @maps
        console.log loc
        _map.grid.set loc, symbol
    
  handleMove: (type, oldLoc, newLoc, json) ->
    if @maps.length
      for _map in @maps
        _map.grid.set oldLoc, 0
        _map.grid.set newLoc, 'm'
    if @towers.length      
      for tower in @towers
        tower.checkTargets (json) ->
          # Add hitcode here    