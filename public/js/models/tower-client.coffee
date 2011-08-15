### Tower client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/tower-model for defintion

$ ->
  class window.Tower
    constructor: (data) ->
      { @uid, @type, @symbol, @damage, @loc} = data
    
    # Draw a tower on the map
    draw: ->
      loc = []
      loc[0] = @getLoc @loc[0]
      loc[1] = @getLoc @loc[1]
      ctx.font = '40pt Pictos'
      ctx.fillText @symbol, loc[0]+2, loc[1]-10

    drawFire: (mob) ->
      loc = []
      loc[0] = @getLoc mob.loc[0]
      loc[1] = @getLoc mob.loc[1]
      ctx.fillStyle = '#F00'
      ctx.font = '20pt Georgia'
      ctx.fillText '-' + @damage, loc[0]+5, loc[1]-20

    getLoc: (loc) ->
       if typeof loc is 'number'
         return (loc*squarewidth)+0.5