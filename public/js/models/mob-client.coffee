### Mob client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/mob-model for defintion

$ ->
  class window.Mob
    constructor: (data) ->
      { @uid, @x, @y, @dx, @dy, @speed, @maxHP, @curHP, @symbol } = data
  
    move: (mobdata) ->
      { @x, @y, @dx, @dy, @speed } = mobdata

    # Update mob info (movement, etc) each frame
    update: (lastUpdate) ->
      distance = (@speed / 1000) * elapsed
      
      # Calculate new trajectory
      @x = @x + (@dx*distance)
      @y = @y + (@dy*distance)
      
    # Draw a mob on the map
    draw: (context) ->
      context.fillStyle='#000'
      x = @getLoc @x
      y = @getLoc @y
      context.font = '40pt Pictos'
      context.fillText @symbol, x+2, y-10

    pause: ->
      console.log 'paused!'
      @dx = 0
      @dy = 0
      
    getLoc: (loc) ->
      return (loc*squarewidth)