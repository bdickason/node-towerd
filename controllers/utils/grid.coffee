### Grid.js - Create a 2d grid for the game board ###
#
# 2d array approach based on these grid benchmarks - https://github.com/shazow/grid-benchmark.js
#
# Usage: 
#   grid = new Grid 20    # Creates a new 20x20 grid
#   grid.set 0,0, 'm'   # changes 0,0 to display 'm'
#   grid.get 1,0        # Returns the value of position 1, 0
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
    
  set: (x, y, value, callback) ->
    if @isInGrid(x, y)
      @grid[x][y] = value
  
  get: (x, y, callback) ->
    if @isInGrid(x, y)
      callback @grid[x][y]

  toString: (callback) ->
    callback @grid.toString()
  
  ### toJSON: (callback) ->
    callback { grid: @grid, w: @w, h: @h } ###

  isInGrid: (x, y) ->
    # Check to make sure it's on the grid
    if x >= 0 and x <= @w and y >= 0 and y <= @h
      return true
    else
      return false

