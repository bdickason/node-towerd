$ -> 
  socket = io.connect 'http://localhost'
  
  ### Game Events ###
  # Initialize core game data on connect
  socket.on 'init', (data) ->
    console.log 'Init event'
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
    # console.log data
    mobdata = data.obj

    # Only move the mob that sent the event
    mob.move mobdata for mob in mobs when mob.uid == mobdata.uid

  socket.on 'fire', (data) ->
    console.log 'Fire event'
    console.log data

    ###    mob = data.target
    tower = data.obj
    drawFire mob, tower ###

  ### Config Variables ###
  window.squarewidth = 50  # Size of one square in the grid
  window.FPS = 300          # Frames per second

  ### on-page actions (clicks, etc) ###
 
  ### Define canvas, etc ###
  window.canvas = document.getElementById 'game_canvas'
  window.ctx = canvas.getContext '2d'

  # Loop to draw the game world each frame
  draw = ->
    if canvas.getContext
      ctx.clearRect 0, 0, canvas.width, canvas.height # Clear the canvas
      #console.log 'Map: ' + map
      #console.log 'Tower: ' + towers
      #console.log 'Mob: ' + mobs
      map.draw()
      tower.draw() for tower in towers
      mob.draw() for mob in mobs
      
  # Start draw loop
  setInterval draw, 1000 / FPS

  ### World Rendering Functions ###


  
  getLoc = (loc) ->
    if typeof loc is 'number'
      return (loc*squarewidth)+0.5
      
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
    
  