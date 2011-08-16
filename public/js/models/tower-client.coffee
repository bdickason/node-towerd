### Tower client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/tower-model for defintion

$ ->
  class window.Tower
    constructor: (data) ->
      { @uid, @type, @symbol, @damage, @x, @y} = data
      x = (@getLoc data.x)+(squarewidth/2)
      y = (@getLoc data.y)-(squarewidth/2)
      @line = {
            x: x,
            y: y,
            length: 32,
            angle: 0
          }
    
    draw: (context) ->
      ### Draw a tower on the map ###
      _x = @getLoc @x
      _y = @getLoc @y
      context.font = '40pt Pictos'
      context.fillText @symbol, _x+2, _y-10
      
      ### Draw the gun ###
      closest = @findClosest()

      # Find angle to closest mob - thanks @hunterloftis for the formula
      triangle_x = (@getLoc closest.x) - @line.x
      triangle_y = (@getLoc closest.y) - @line.y
      @line.angle = Math.atan2 triangle_y, triangle_x
      
      new_x = @line.x + @line.length * Math.cos @line.angle 
      new_y = @line.y + @line.length * Math.sin @line.angle
      
      context.strokeStyle = '#f00'
      context.lineWidth = 3
      context.beginPath()
      context.moveTo @line.x, @line.y
      context.lineTo new_x, new_y
      context.stroke()
      
    drawFire: (context, mob) ->
      _x = @getLoc mob.x
      _y = @getLoc mob.y
      context.fillStyle = '#F00'
      context.font = '20pt Georgia'
      context.fillText '-' + @damage, _x+5, _y-20

    getLoc: (loc) ->
       if typeof loc is 'number'
         return (loc*squarewidth)+0.5
    
    findClosest: ->
      # Find the closest mob so you can aim at it!
      closest = null
      closest_distance = 9999999  # Infinitely big number for our purposes
      for mob in mobs
        distance = @square(@x - mob.x) + @square(@y - mob.y)
        if distance < closest_distance
          closest = mob
          closest_distance = distance
      return closest
    
    square: (num) ->
      return num*num
      
        
        