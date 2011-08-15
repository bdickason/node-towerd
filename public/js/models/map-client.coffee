### Map (grid) client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/map-model for defintion
$ -> 
  class window.Map
    constructor: (data) ->
      { @uid, @size } = data
  
    # Draw a square grid based on size denoted by the server
    draw: ->
      # Draw the map    
      for x in [0..@size] by 1
        ctx.moveTo @getLoc(x), @getLoc(0)
        ctx.lineTo @getLoc(x), @getLoc(@size)
        ctx.moveTo @getLoc(0), @getLoc(x)
        ctx.lineTo @getLoc(@size), @getLoc(x)

      ctx.strokeStyle = '#000'
      ctx.stroke()

    getLoc: (loc) ->
       if typeof loc is 'number'
         return (loc*squarewidth)+0.5