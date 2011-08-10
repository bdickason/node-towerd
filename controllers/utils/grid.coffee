### Grid.js - Create a 2d grid for the game board ###
# Usage: 
#   grid = new Grid 20    # Creates a new 20x20 grid
#   grid.set [0,0], 'm'   # changes 0,0 to display 'm'
#   grid.get [1,0]        # Returns the value of position 1, 0
#   grid.toString()       # Returns a nice pretty grid string


exports.Grid = class Grid
  constructor: (size) ->
    # Fills an empty array with 0's
    @grid = []
    @w = size
    @h = size
    
    for x in [@w..0]
      row = []
      for y in [@h..0] 
        row.push(0)
      @grid.push(row);
    
  set: (loc, value, callback) ->
    @grid[loc[0]][loc[1]] = value
  
  get: (loc, callback) ->
    callback @grid[loc[0]][loc[1]]

  toString: (callback) ->
    callback @grid.toString()
  
  toJSON: (callback) ->
    callback { grid: @grid, w: @w, h: @h}

