### Player client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /controllers/player-model for defintion

$ ->
  class window.Player
    constructor: (data) ->      
      # Server-side data { @uid, @x, @y, @dx, @dy, @name, @speed, @maxHP, @curHP, @symbol } = data
      
      ### Hack -- Client side movement ###
      @x = 5
      @y = 5
      @dx = 0
      @dy = 0
      @symbol = 'U'
      @speed = 3
      @curHP = 50
      @maxHP = 50
      ### End Hack! ###
      
      @type = 'player'
      @layer = 'fg' # Players should render to the foreground layer
      
      # List of possible player's actions
      @attacking = false
      @movingLeft = false
      @movingRight = false
      @movingUp = false
      @movingDown = false
      @pooping = false
  
    move: (data) ->
      ### Server-side movement code
      if @curHP > 0 # Don't move when the player is dead
        {@dx, @dy, @speed, @curHP, @maxHP } = data
      ###

    
    die: (data) ->
      { @x, @y, @dx, @dy, @curHP, @maxHP } = data
      @symbol = '*'

    # Update player info (movement, etc) each frame
    update: (elapsed) ->
      distance = (@speed / 1000) * elapsed * 1.71   # Hack - movement constant for smooth movement
      
      # If the player does nothing, stand still!
      @dx = 0
      @dy = 0
      if @movingLeft
        @dx = -1
      if @movingRight
        @dx = 1
      if @movingUp
        @dy = 1
      if @movingDown
        @dy = -1
        
      # Calculate new trajectory
      @x = @x + (@dx*distance)
      @y = @y + (@dy*distance)

    pause: ->
      @dx = 0
      @dy = 0
      
    getLoc: (loc) ->
      return (loc*squarewidth)