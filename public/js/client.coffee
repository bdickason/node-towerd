socket = io.connect 'http://localhost'

### Config Variables ###
squarewidth = 50  # Size of one square in the grid

$ ->
  ### Game Events ###

  # Initialize core game data on connect
  socket.on 'init', (data) ->
    console.log 'Init event'
    
    # cleanup the ugly socket-io data
    map = data.data.map
    mobs = data.data.mobs
    towers = data.data.towers
    
    if canvas.getContext
      drawGrid map.size  
      drawMob mob for mob in mobs
      drawTower tower for tower in towers

  # Load an object's resources into memory
  socket.on 'load', (data) ->
    console.log 'Load event'
    console.log data

  # Spawn an object on the canvas
  socket.on 'spawn', (data) ->
    console.log 'Spawn event'
    console.log data
  
  # Move an object across the canvas
  socket.on 'move', (data) ->
    console.log 'Move event'
    console.log data
    mob = data.obj
    oldloc = data.oldloc
    drawMob mob, oldloc

  socket.on 'fire', (data) ->
    console.log 'Fire event'
    console.log data
  
  ### Initialize Canvas ###
  canvas = document.getElementById 'game_canvas'
  context = canvas.getContext '2d'
  
  ### World Rendering Functions ###
  
  # Draw a square grid based on size denoted by the server
  drawGrid = (size) ->
    # Draw the map    
    for x in [0..size] by 1
      context.moveTo getLoc(x), getLoc(0)
      context.lineTo getLoc(x), getLoc(size)
      context.moveTo getLoc(0), getLoc(x)
      context.lineTo getLoc(size), getLoc(x)

    context.strokeStyle = '#000'
    context.stroke()
  
  # Draw a mob on the map
  drawMob = (mob, oldloc) ->
    if oldloc
      _loc = []
      _loc[0] = getLoc oldloc[0]
      _loc[1] = getLoc oldloc[1]
      # get rid of the old one first
      context.fillStyle='#FFF'
      context.fillRect _loc[0], _loc[1], 25, 25 # Guesstimate at the width of one mob
    context.fillStyle='#000'
    loc = []
    loc[0] = getLoc mob.loc[0]
    loc[1] = getLoc mob.loc[1]
    context.font = 'bold 5em'
    console.log 'Drawing Mob: at ' + loc[0] + ', ' + loc[1]    
    context.fillText mob.symbol, loc[0], loc[1]
    
  # Draw a tower on the map
  drawTower = (tower) =>
    loc = []
    loc[0] = getLoc tower.loc[0]
    loc[1] = getLoc tower.loc[1]
    context.font = 'bold 5em'
    context.fillText tower.symbol, loc[0], loc[1]

    
  getLoc = (loc) ->
    if typeof loc is 'number'
      return (loc*squarewidth)+0.5


  ### on-page actions (clicks, etc) ###
  
  $('#start').click ->
    console.log 'test'
    socket.emit 'start', { }
    $('#start').html('Game started').unbind 'click'


  ### Define canvas, etc ###
  canvas = document.getElementById 'game_canvas'