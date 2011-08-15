socket = io.connect 'http://localhost'

### Config Variables ###
squarewidth = 50  # Size of one square in the grid
FPS = 30          # Frames per second

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
      drawGrid map.size, data.data.cfg.tileSize 
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
    mob = data.target
    tower = data.obj
    drawFire mob, tower

  
  ### Initialize Canvas ###
  canvas = document.getElementById 'game_canvas'
  ctx = canvas.getContext '2d'
  setInterval draw, 1000 / FPS
  
  ### World Rendering Functions ###
  
  # Loop to draw the game world each frame
  draw = ->
    # ctx.clearRect 0, 0, canvas.width, canvas.height # Clear the canvas
    
    
  
  # Draw a square grid based on size denoted by the server
  drawGrid = (size) ->
    # Draw the map    
    for x in [0..size] by 1
      ctx.moveTo getLoc(x), getLoc(0)
      ctx.lineTo getLoc(x), getLoc(size)
      ctx.moveTo getLoc(0), getLoc(x)
      ctx.lineTo getLoc(size), getLoc(x)

    ctx.strokeStyle = '#000'
    ctx.stroke()
  
  # Draw a mob on the map
  drawMob = (mob, oldloc) ->
    if oldloc
      _loc = []
      _loc[0] = getLoc oldloc[0]
      _loc[1] = getLoc oldloc[1]
      # get rid of the old one first
      ctx.fillStyle='#FFF'
      ctx.fillRect _loc[0]+1, _loc[1]-49, 48, 48 # Guesstimate at the width of one mob
      
    ctx.fillStyle='#000'
    loc = []
    loc[0] = getLoc mob.loc[0]
    loc[1] = getLoc mob.loc[1]
    ctx.font = '40pt Pictos'
    ctx.fillText mob.symbol, loc[0]+2, loc[1]-10
    
  # Draw a tower on the map
  drawTower = (tower) =>
    loc = []
    loc[0] = getLoc tower.loc[0]
    loc[1] = getLoc tower.loc[1]
    ctx.font = '40pt Pictos'
    ctx.fillText tower.symbol, loc[0]+2, loc[1]-10

  drawFire = (mob, tower) =>
    loc = []
    loc[0] = getLoc mob.loc[0]
    loc[1] = getLoc mob.loc[1]
    ctx.fillStyle = '#F00'
    ctx.font = '20pt Georgia'
    ctx.fillText '-' + tower.damage, loc[0]+5, loc[1]-20
    
  getLoc = (loc) ->
    if typeof loc is 'number'
      return (loc*squarewidth)+0.5

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
    
    
  ### Define canvas, etc ###
  canvas = document.getElementById 'game_canvas'