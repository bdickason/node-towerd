$ -> 
  ### Config Variables ###
  window.squarewidth = 50  # Size of one square in the grid
  window.FPS = 30          # Frames per second
  
  ### Reserved Variables ###
  window.bullets = []

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
    
  # Load an object's resources into memory
  socket.on 'load', (data) ->
    console.log 'Load event'
    # console.log data

  # Spawn an object on the canvas
  socket.on 'spawn', (data) ->
    console.log 'Spawn event'
    # console.log data

  # Move an object across the canvas
  socket.on 'move', (data) ->
    console.log 'Move event'

    # Only move the mob that sent the event
    mob.move data for mob in mobs when mob.uid == data.uid

  socket.on 'fire', (data) ->
    console.log 'Fire event'
    # towers[0].drawFire fg_ctx
 
  ### Define canvas, etc ###
  window.fg_canvas = document.getElementById 'game_canvas'
  window.fg_ctx = fg_canvas.getContext '2d'
  
  window.bg_canvas = document.getElementById 'game_background'
  window.bg_ctx = bg_canvas.getContext '2d'


  # Loop to draw the game world each frame
  draw = ->
    if fg_canvas.getContext
      fg_ctx.clearRect 0, 0, fg_canvas.width, fg_canvas.height # Clear the canvas
      tower.draw fg_ctx for tower in towers
      mob.draw fg_ctx for mob in mobs
      
  # Start draw loop
  setInterval draw, 1000 / FPS

  ### World Rendering Functions ###

  ### on-page actions (clicks, etc) ###
  
  # Play/Pause button
  $('#toggle').bind 'click', ->
    if $(@).attr('class') == 'play'
      socket.emit 'start', { }
      $(@).html('5').attr('class', 'pause')
    else
      socket.emit 'pause', { }
      $(@).html('4').attr('class', 'play')
      
    $('#start').html('Game started').click ->
      socket.emit 'pause', { }

  $('#tower').click ->
    console.log 'adding tower'
    
  