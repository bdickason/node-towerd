### Tower client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/tower-model for defintion

$ ->
  class window.Tower
    constructor: (data) ->
      { @uid, @type, @symbol, @damage, @loc} = data
      x = (@getLoc data.loc[0])+(squarewidth/2)
      y = (@getLoc data.loc[1])-(squarewidth/2)
      @line = {
            x: x,
            y: y,
            length: 32,
            angle: 0
          }
    
    draw: (context) ->
      ### Draw a tower on the map ###
      loc = []
      loc[0] = @getLoc @loc[0]
      loc[1] = @getLoc @loc[1]
      context.font = '40pt Pictos'
      context.fillText @symbol, loc[0]+2, loc[1]-10
      
      ### Draw the gun ###
      closest = @findClosest()

      # Find angle to closest mob - thanks @hunterloftis for the formula
      triangle_x = (@getLoc closest.loc[0]) - @line.x
      triangle_y = (@getLoc closest.loc[1]) - @line.y
      @line.angle = Math.atan2 triangle_y, triangle_x
      
      new_x = @line.x + @line.length * Math.cos @line.angle 
      new_y = @line.y + @line.length * Math.sin @line.angle
      
      context.strokeStyle = '#f00'
      context.lineWidth = 3
      context.beginPath()
      context.moveTo @line.x, @line.y
      context.lineTo new_x, new_y
      context.stroke()
      
      console.log 'X: ' + new_x + ' Y: ' + new_y
      
    drawFire: (context, mob) ->
      loc = []
      loc[0] = @getLoc mob.loc[0]
      loc[1] = @getLoc mob.loc[1]
      context.fillStyle = '#F00'
      context.font = '20pt Georgia'
      context.fillText '-' + @damage, loc[0]+5, loc[1]-20

    getLoc: (loc) ->
       if typeof loc is 'number'
         return (loc*squarewidth)+0.5
    
    findClosest: ->
      # Find the closest mob so you can aim at it!
      closest = null
      closest_distance = 9999999  # Infinitely big number for our purposes
      for mob in mobs
        distance = @square(@loc[0] - mob.loc[0]) + @square(@loc[1] - mob.loc[1])
        if distance < closest_distance
          closest = mob
          closest_distance = distance
      return closest
    
    square: (num) ->
      return num*num
      
        
        