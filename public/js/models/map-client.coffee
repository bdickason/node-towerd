### Map (grid) client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/map-model for defintion
$ -> 
  class window.Map
    constructor: (data) ->
      { @uid, @size, @end_x, @end_y } = data
      @draw(bg_ctx)
  
    # Draw a square grid based on size denoted by the server
    draw: (context) ->
      # Draw the map    
      for x in [0..@size] by 1
        context.moveTo @getLoc(x), @getLoc(0)
        context.lineTo @getLoc(x), @getLoc(@size)
        context.moveTo @getLoc(0), @getLoc(x)
        context.lineTo @getLoc(@size), @getLoc(x)

      context.strokeStyle = '#000'
      context.stroke()
      
      # Draw the exit
      context.fillStyle = '#f00'
      context.fillRect @getLoc(@end_x), @getLoc(@end_y), squarewidth, squarewidth
      console.log 'Filling rect: ' + @end_x + ' ' + @end_y

    getLoc: (loc) ->
       if typeof loc is 'number'
         return (loc*squarewidth)+0.5 