### Mob client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/mob-model for defintion

$ ->
  class window.Mob
    constructor: (data) ->
      { @uid, @loc, @dx, @dy, @speed, @maxHP, @curHP, @symbol } = data
  
    move: (mobdata) ->
      { @loc, @dx, @dy, @speed } = mobdata

    # Draw a mob on the map
    draw: (context) ->
      # Calculate new trajectory for each redraw
      @loc[0] = @loc[0] + (@dx*@speed/FPS)
      @loc[1] = @loc[1] + (@dx*@speed/FPS)
      
      context.fillStyle='#000'

      loc = []
      loc[0] = @getLoc @loc[0]
      loc[1] = @getLoc @loc[1]
      context.font = '40pt Pictos'
      context.fillText @symbol, loc[0]+2, loc[1]-10
    
    getLoc: (loc) ->
       if typeof loc is 'number'
         return (loc*squarewidth)+0.5