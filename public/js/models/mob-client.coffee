### Mob client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/mob-model for defintion

$ ->
  class window.Mob
    constructor: (data) ->
      @moveConst = 1.7
      { @uid, @x, @y, @dx, @dy, @speed, @maxHP, @curHP, @symbol } = data
  
    move: (mobdata) ->
      { @x, @y, @dx, @dy, @speed } = mobdata

    # Draw a mob on the map
    draw: (context) ->
      # Calculate new trajectory for each redraw
      @x = @x + (@dx*@speed*@moveConst/FPS)
      @y = @y + (@dx*@speed*@moveConst/FPS)
      
      context.fillStyle='#000'

      x = @getLoc @x
      y = @getLoc @y
      context.font = '40pt Pictos'
      context.fillText @symbol, x+2, y-10
    
    getLoc: (loc) ->
       if typeof loc is 'number'
         return (loc*squarewidth)+0.5