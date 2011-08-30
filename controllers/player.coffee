cfg = require '../config/config.js'    # contains API keys, etc.
EventEmitter = (require 'events').EventEmitter

# Models

exports.Player = class Player extends EventEmitter
  constructor: (uid, world) ->
    @type = 'player'

    @uid = uid  # uid is the player's session ID to make things easier

    @x = 5 # Hack - spawn the player at 5, 5 for now!
    @y = 5
    { @dx, @dy } = 0 # Player will be stationary when spawned

    @name = 'Bobbin Threadbare'
    @active = 1
    @speed = 3
    @maxHP = 50
    @curHP = @maxHP
    @symbol = 'U'
  
    @emit 'load'
    
    ### Event Emitters ###
    world.on 'gameLoop', =>
      @move world, (json) ->
    
    world.on 'playermove', (obj) =>
      if obj.uid == @uid  # I'm moving!
        @dx = obj.dx
        @dy = obj.dy
    
  move: ->
    # Process any player movement
    if @curHP > 0   # Make sure I'm not dead
      old_x = @x
      old_y = @y
      
      @x += @dx * @speed
      @y += @dy * @speed
      
      @emit 'move', old_x, old_y
      
    else
      @dx = 0   # I died. Stop moving me, it's creepy.
      @dy = 0
    
