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
    draw: (oldloc) ->
      console.log 'drawing mob: ' + @
      if oldloc
        _loc = []
        _loc[0] = @getLoc oldloc[0]
        _loc[1] = @getLoc oldloc[1]
        # get rid of the old one first
        ctx.fillStyle='#FFF'
        ctx.fillRect _loc[0]+1, _loc[1]-49, 48, 48 # Guesstimate at the width of one mob
      ctx.fillStyle='#000'
      loc = []
      loc[0] = @getLoc @loc[0]
      loc[1] = @getLoc @loc[1]
      ctx.font = '40pt Pictos'
      ctx.fillText @symbol, loc[0]+2, loc[1]-10
    
    getLoc: (loc) ->
       if typeof loc is 'number'
         return (loc*squarewidth)+0.5