### World - Runs the game world like a pro! ###

EventEmitter = (require 'events').EventEmitter
# TODO - rename 'map' to 'Map' etc.
Map = (require './controllers/maps').Map  # Map functions like render, etc.
Mob = (require './controllers/mobs').Mob  # Mob functions like move, etc.
Tower = (require './controllers/towers').Tower  # Tower functions like attack, etc.

# Initialize a new game
# Called when the player first starts or elects to restart

exports.World = class World extends EventEmitter

  constructor: (app) ->
    ### Initial config ###
    @gameTime = 2000  # every n ms, the game progresses

    # For some reason we have to wait to load everything or else 'world' doesn't get defined as a global var
    @load = setTimeout =>
      @loadEntities( { map: 'hiddenvalley' } )
    , 1000

  ### Start the game!! ###
  start: ->
    @game = setInterval ->
      world.gameLoop()
    , @gameTime
  
  loadEntities: (json, callback) ->
    
    ### Load the map ###
    # First level: Hidden Valley
    @maps = []
    @maps.push new Map json.map
    @emit 'load', 'map', map for map in @maps

    ### Load and spawn the towers ###
    # First map has one tower: Cannon
    @towers = []
    @towers.push new Tower 'cannon'

        
    ### Load the mobs ###
    # Each map can have many mobs
    @mobs = []
    for map in @maps
      for mobId in map.mobs
        mob = new Mob mobId
        @emit 'load', 'mob', mob
        @mobs.push mob

    # Mobs don't know about the 'load' event because they aren't instantiated in time
    @emit 'load', 'tower', tower for tower in @towers

    # They exist in memory but need to be spawned
    @mobs[0].spawn [0, 0]
    @mobs[1].spawn [1, 0]
    @towers[0].spawn [4, 4]

         
  gameLoop: ->
    # One iteration of a game loop
    # Runs every '@gameTime' seconds
    @emit 'gameLoop'  # A bunch of stuff listens to this to know when a 'turn' has finished    

    @toString (json) ->
      console.log json  # Have to log via console because of this lame array.
    
  destroy: ->
    logger.info 'DESTROYING the game ;('
    clearInterval @game # stop game clock
    maps = []
    mobs = []
    towers = []
  
  
  # Output current game status
  toString: (callback) ->
    callback @maps[0].grid
    