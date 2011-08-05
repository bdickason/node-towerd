maps = (require './maps').Maps  # Map functions like render, etc.
mobs = (require './mobs').Mobs  # Mob functions like move, etc.

# towers = require ('./towers').towers  # Tower functions like attack, etc. 

# Initialize a new game
# Called when the player first starts or elects to restart

exports.Game = class Game

  ### Load the map ###
  # First level: Hidden Valley
  map = new maps 'hiddenvalley'
  
  console.log map
  
  ### Load the mobs ###
  # First map has one mob: Warrior
  mob = new mobs 'warrior'

  mob.spawn 0, 0, 0, (json) ->
    console.log 'Mob: ' + mob
  
  mob.move 1, 1, (json) ->
    console.log 'Mob: ' + mob
    
  
  ### Load the towers ###
  # First map has one tower: Cannon
  # tower = require ('../data/mobs/tower.js').tower