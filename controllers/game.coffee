map = (require './maps').Map  # Map functions like render, etc.
mob = (require './mobs').Mob  # Mob functions like move, etc.
tower = (require './towers').Tower  # Tower functions like attack, etc. 

# Initialize a new game
# Called when the player first starts or elects to restart

exports.Game = class Game

  constructor: ->
    ### Load the map ###
    # First level: Hidden Valley
    @maps = []
    @maps.push new map 'hiddenvalley'
    
    @maps[0].save ->
  
    ### Load the mobs ###
    # First map has one mob: Warrior
    @mobs = []
  
    # Let's create two of them  
    @mobs.push new mob @maps[0].mobs[0]
    @mobs.push new mob @maps[0].mobs[0]

    # They exist in memory but need to be spawned
    @mobs[0].spawn 0, 0, (json) ->
      console.log 'Mob: ' + mob
    @mobs[1].spawn 1, 0, (json) ->
      console.log 'Mob: ' + mob
  
    # Now make 'em move.
    @mobs[0].move 1, 0, (json) ->
    @mobs[1].move 0, 1, (json) ->
    
    # Print basic info about the mob
    @mobs[0].toString (json) ->
      console.log json
    @mobs[1].toString (json) ->
      console.log json
    
    @mobs[0].save ->
    @mobs[1].save ->
  
    ### Load the towers ###
    # First map has one tower: Cannon
    @towers = []
  
    # Let's create it
    @towers.push new tower 'cannon'
  
    # Spawn it
    @towers[0].spawn 4, 4, (json) ->
      console.log 'Tower: ' + json
  
    # Print basic info about the tower
    @towers[0].toString (json) ->
      console.log json
    
    @towers[0].save ->
    
    @towers[0].checkTargets ->
    
  
  destroy: ->
    console.log 'DESTROYING the game ;('
    maps = []
    mobs = []
    towers = []
  
  # Output current game status
  toString: (json) ->
    
    for map in @maps
      do (map) ->
        map.toString (json) ->
          console.log json

    for mob in @mobs
      do (mob) ->
        mob.toString (json) ->
          console.log json
    
    for tower in @towers
      do (tower) ->
        tower.toString (json) ->
          console.log json
