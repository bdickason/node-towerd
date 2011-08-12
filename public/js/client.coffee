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
  
$ ->
  $('#start').click ->
    console.log 'test'
    socket.emit 'start', { }
    $('#start').html('Game started').unbind 'click'