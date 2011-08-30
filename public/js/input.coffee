### Input - Player stuffs ###

# Based on stackoverflow advice, I've moved all client-side input code to this class
  
$ ->
  class window.Input
    constructor: ->
      
      @keys = []

      # Initialize keyboard events
      window.addEventListener 'keydown', (e) =>
        # Keypress means the player wants to do... something!
        # Don't do anything but let the program know for the next game loop.
        @keys[e.keyCode] = true
      , false
      
      window.addEventListener 'keyup', (e) =>
        # ok they let go of the key
        @keys[e.keyCode] = false
      , false
        
        
      
    handle: ->
      # Now we respond to the click!
      if @keys[37]
        # Left Arrow'
        player.movingLeft = true
      else
        window.player.movingLeft = false
        
      if @keys[39]
        # Right Arrow
        window.player.movingRight = true
      else
        window.player.movingRight = false
        
      if @keys[38]
        # Down Arrow
        window.player.movingDown = true
      else
        window.player.movingDown = false
        
      if @keys[40]
        # Up Arrow
        window.player.movingUp = true
      else
        window.player.movingUp = false