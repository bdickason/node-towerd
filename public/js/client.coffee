$ -> 
  ### Config Variables ###
  window.squarewidth = 50  # Size of one square in the grid
  window.FPS = 30          # Frames per second
  
  ### Reserved Variables ###
  window.bullets = []
  window.startTime = Date.now()
  window.elapsed = 0
  lastUpdate = startTime

  socket = io.connect 'http://localhost'
  
  ### Game Events ###
  # Initialize core game data on connect
  socket.on 'init', (data) ->
    console.log 'Init event'
    
    window.mapChanged = 1 # If mapchanged = 1, redraw the map
    
    # cleanup the ugly socket-io data
    _map = data.data.map
    _mobs = data.data.mobs
    _towers = data.data.towers

    window.mobs = []
    window.towers = []

    window.map = new Map _map
    mobs.push new Mob mob for mob in _mobs
    towers.push new Tower tower for tower in _towers
    r.draw map
    
  # Load an object's resources into memory
  socket.on 'load', (data) ->
    console.log 'Load event'
    # console.log data

  # Spawn an object on the canvas
  socket.on 'spawn', (data) ->
    switch data.type
      when 'tower'
        console.log 'Spawning tower'
        console.log data
        
        towers.push new Tower data

  # Move an object across the canvas
  socket.on 'move', (data) ->
    # Only move the mob that sent the event
    mob.move data for mob in mobs when mob.uid == data.uid

  socket.on 'fire', (data) ->
    tower.fire() for tower in towers when tower.uid == data.obj.uid
  
  socket.on 'die', (data) ->
    mob.die data for mob in mobs when mob.uid == data.uid
 
  ### Define canvas, etc ###
  window.fg_canvas = document.getElementById 'game_canvas'
  window.fg_ctx = fg_canvas.getContext '2d'
  
  window.bg_canvas = document.getElementById 'game_background'
  window.bg_ctx = bg_canvas.getContext '2d'
  
  window.r = new Render bg_ctx, fg_ctx   # r is our rendererererer
  

  # Traditional game loop!
  game = ->
    handleInput()
    update()
    draw()

  # Handle player input once per loop
  handleInput = ->
    # Respond to a player's click
    
  # Update Game world (moves, etc)
  update = ->
    # Calculate time from last frame to current for a game 'tick'
    # For more info: http://www.html5rocks.com/en/tutorials/casestudies/onslaught.html#toc-the-game-loop
    now = Date.now()
    elapsed = now - lastUpdate
    lastUpdate = now
    
    tower.update() for tower in towers
    mob.update(elapsed) for mob in mobs
    
  # Draw the game world each frame
  draw = ->
    if fg_canvas.getContext
      fg_ctx.clearRect 0, 0, fg_canvas.width, fg_canvas.height # Clear the canvas
      r.draw tower for tower in towers
      r.draw mob for mob in mobs
  

  ### World Rendering Functions ###
  window.gameLoop = setInterval game, 1000 / FPS
  
  ### on-page actions (clicks, etc) ###
  
  # Play/Pause button
  $('#toggle').bind 'click', ->
    if $(@).attr('class') == 'play'
      # Start the game loop
      window.gameLoop = setInterval game, 1000 / FPS
      socket.emit 'start', { }
      $(@).html('5').attr('class', 'pause')
    else
      # Pause the game loop
      clearInterval gameLoop
      socket.emit 'pause', { }
      mob.pause() for mob in mobs
      $(@).html('4').attr('class', 'play')
      
    $('#start').html('Game started').click ->
      socket.emit 'pause', { }
  
  $('#game_canvas').click (e) ->
    socket.emit 'add', 'tower', reverseLoc(e.offsetX), reverseLoc(e.offsetY)
  
  reverseLoc = (loc) ->
    # Calculate which square in the grid the user clicked
    return Math.floor (loc)/squarewidth

  