map = (require './maps').Map  # Map functions like render, etc.
mob = (require './mobs').Mob  # Mob functions like move, etc.
tower = (require './towers').Tower  # Tower functions like attack, etc. 
EventEmitter = (require 'events').EventEmitter


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
    
    ### Load the map ###
    # First level: Hidden Valley
    @maps = []
    @maps.push new map 'hiddenvalley'
        
    ### Load the mobs ###
    # First map has one mob: Warrior
    @mobs = []
  
    # Let's create two of them  
    @mobs.push new mob @maps[0].mobs[0]
    @mobs.push new mob @maps[0].mobs[0]

    ### Load the towers ###
    # First map has one tower: Cannon
    @towers = []
  
    # Let's create it
    @towers.push new tower 'cannon'


    # Add event listeners so the Tower + Map know if they move
    self = @ # hack for scope inside closure
    
    @towers[0].on 'spawn', (type, loc, json) ->
      self.handleSpawn type, loc, (json) ->
        console.log 'finished spawn'

    @mobs[0].on 'spawn', (type, loc, json) ->
      self.handleSpawn type, loc, (json) ->
        console.log 'finished spawn'
    @mobs[1].on 'spawn', (type, loc, json) ->
      self.handleSpawn type, loc, (json) ->
        console.log 'finished spawn'
    
    @mobs[0].on 'move', (type, oldLoc, newLoc, json) ->
      self.handleMove type, oldLoc, newLoc, (json) ->
        console.log 'finished move'
    @mobs[1].on 'move', (type, oldLoc, newLoc, json) ->
      self.handleMove type, oldLoc, newLoc, (json) ->
        console.log 'finished move'


    
    # They exist in memory but need to be spawned
    @mobs[0].spawn 0, 0, (json) ->
      console.log 'Mob: ' + mob
    @mobs[1].spawn 1, 0, (json) ->
      console.log 'Mob: ' + mob      
  
    @towers[0].spawn 4, 4, (json) ->
      console.log 'Tower: ' + json
  
    @maps[0].save ->    
    @towers[0].save ->
    @mobs[0].save ->
    @mobs[1].save ->    

         
  gameLoop: ->
    # One iteration of a game loop
    # Runs every '@gameTime' seconds
    @emit 'gameLoop'
    for mob in @mobs
      mob.move 1, 1, (json) ->
    
    @toString (json) ->
      console.log json
    
  destroy: ->
    console.log 'DESTROYING the game ;('
    clearInterval @game # stop game clock
    maps = []
    mobs = []
    towers = []
  
  
  # Output current game status
  toString: (callback) ->
    callback @maps[0].grid.grid
    
  
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