### Render - Draws everything! ###

# Based on stackoverflow advice, I've moved all client-side draw code to this class
  
$ ->
  class window.Render
    constructor: (bg, fg) ->
      @fg = fg  # Foreground canvas context
      @bg = bg  # Background canvas context
    
    draw: (obj) ->
      # Draws an entity on the canvas
      switch obj.layer
        when 'fg'
          context = @fg
        when 'bg'
          context = @bg
          
      switch obj.type
        when 'mob'
          @drawMob obj, context
        when 'tower'
          @drawTower obj, context
        when 'map'
          @drawMap obj, context

    # Draw a mob on the map
    drawMob: (obj, context) ->
      context.fillStyle='#000'
      x = obj.getLoc obj.x
      y = obj.getLoc obj.y
      context.font = '40pt Pictos'
      context.fillText obj.symbol, x+1, y+40 # Add 40 because fonts draw from top left

    # Draw a tower on the map
    drawTower: (obj, context) ->

      _x = obj.getLoc obj.x
      _y = obj.getLoc obj.y
      context.font = '40pt Pictos'
      context.fillText obj.symbol, _x+2, _y+40 # Add 40 because fonts draw from top left


      # Draw the gun
      context.strokeStyle = '#f00'
      context.lineWidth = 3
      context.beginPath()
      context.moveTo obj.line.x, obj.line.y+50
      context.lineTo obj.line.end_x, obj.line.end_y+50
      context.stroke()

      # Only call drawfire if we have a few bullets!
      if bullets.length > 0
        @drawFire context

    drawFire: (context) ->
      for bullet in bullets
        bullet.draw context

    # Draw a square grid based on size denoted by the server
     drawMap: (obj, context) ->
       # Draw the map    
       for x in [0..obj.size] by 1
         context.moveTo obj.getLoc(x), obj.getLoc(0)
         context.lineTo obj.getLoc(x), obj.getLoc(obj.size)
         context.moveTo obj.getLoc(0), obj.getLoc(x)
         context.lineTo obj.getLoc(obj.size), obj.getLoc(x)

       context.strokeStyle = '#000'
       context.stroke()

       # Draw the exit
       context.fillStyle = '#f00'
       context.fillRect obj.getLoc(obj.end_x), obj.getLoc(obj.end_y), squarewidth, squarewidth