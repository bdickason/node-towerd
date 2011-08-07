### Utils.js - Quick utility classes for stuff like:
      -Creating a game grid
      -etc.
###
      


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
    console.log 'loc: ' + loc
    console.log 'value: ' + value
    @grid[loc[0]][loc[1]] = value
  
  get: (loc, callback) ->
    callback @grid[loc[0]][loc[1]]

  toString: (callback) ->
    console.log 'hit this'
    callback @grid.toString()  

