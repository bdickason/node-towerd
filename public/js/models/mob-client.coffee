### Mob client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/mob-model for defintion

$ ->
  class window.Mob
    constructor: (data) ->
      { @uid, @x, @y, @dx, @dy, @speed, @maxHP, @curHP, @symbol } = data
  
    move: (mobdata) ->
      if @curHP > 0 # Don't move when the mob is dead
        {@dx, @dy, @speed } = mobdata
    
    die: (mobdata) ->
      { @x, @y, @dx, @dy, @curHP, @maxHP } = mobdata
      @symbol = '*'

    # Update mob info (movement, etc) each frame
    update: (elapsed) ->
      distance = (@speed / 1000) * elapsed * 1.71
      
      # Calculate new trajectory
      @x = @x + (@dx*distance)
      @y = @y + (@dy*distance)
      
    # Draw a mob on the map
    draw: (context) ->
      context.fillStyle='#000'
      x = @getLoc @x
      y = @getLoc @y
      context.font = '40pt Pictos'
      context.fillText @symbol, x+1, y+40 # Add 40 because fonts draw from top left

    pause: ->
      @dx = 0
      @dy = 0
      
    getLoc: (loc) ->
      return (loc*squarewidth)