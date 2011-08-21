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
    
    fire: ->
      if bullets.length < 20
        for i in [0..5] 
          bullet = new Bullet @line.end_x, @line.end_y, 2
          random_offset = Math.random() * 1 - .5
          speed = Math.random() * 15 + 3
          bullet.vx = speed * Math.cos(@line.angle + random_offset);
          bullet.vy = speed * Math.sin(@line.angle + random_offset);
    
    update: ->
      ### Find closest mob and lock on ###
      closest = @findClosest()

      if closest
        # Find angle to closest mob - thanks @hunterloftis for the formula
        triangle_x = (@getLoc closest.x) - @line.x
        triangle_y = (@getLoc closest.y) - @line.y
        @line.angle = Math.atan2 triangle_y, triangle_x
      
        @line.end_x = @line.x + @line.length * Math.cos @line.angle 
        @line.end_y = @line.y + @line.length * Math.sin @line.angle
      
      # Update bullet movement
      for bullet in bullets
        bullet.x += bullet.vx
        bullet.y += bullet.vy
        bullet.vy += .1
        bullet.vx *= .999
        bullet.vy *= .99
    
        if bullet.x % fg_canvas.width != bullet.x
          bullet.remove()
        else if bullet.x >= fg_canvas.height
          bullet.vy = -Math.abs bullet.vy
          bullet.vy *= .7
          if Math.abs bullet.vy < 1 && Math.abs bullet.vx < 1
            bullet.remove()     
    
    draw: (context) ->
      ### Draw a tower on the map ###
      _x = @getLoc @x
      _y = @getLoc @y
      context.font = '40pt Pictos'
      context.fillText @symbol, _x+2, _y-10
      

      ### Draw the gun ###
      context.strokeStyle = '#f00'
      context.lineWidth = 3
      context.beginPath()
      context.moveTo @line.x, @line.y
      context.lineTo @line.end_x, @line.end_y
      context.stroke()
      
      # Only call drawfire if we have a few bullets!
      if bullets.length > 0
        @drawFire context
      
    drawFire: (context) ->
      for bullet in bullets
        bullet.draw context
        
    getLoc: (loc) ->
      return (loc*squarewidth)
    
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
      
        
    