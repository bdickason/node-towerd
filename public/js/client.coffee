socket = io.connect 'http://localhost'

### Game Events ###

# Load an object's resources into memory
socket.on 'load', (data) ->
  console.log data

# Spawn an object on the canvas
socket.on 'spawn', (data) ->
  console.log data
  
# Move an object across the canvas
socket.on 'move', (data) ->
  console.log data.obj.loc
  
### Initialize Canvas ###
drawGrid = ->
  canvas = document.getElementById 'game_canvas'
  context = canvas.getContext '2d'
  
  context.fillStyle = 'rgb(200,0,0)'
  context.fillRect 10, 10, 100, 100
  

$ ->
  $('#start').click ->
    console.log 'test'
    socket.emit 'start', { }
    $('#start').html('Game started').unbind 'click'
  
  canvas = document.getElementById 'game_canvas'
  console.log 'found canvas'
  if canvas.getContext
    drawGrid()