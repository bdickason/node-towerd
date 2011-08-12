socket = io.connect 'http://localhost'

### Game Events ###

# Load an object's resources into memory
socket.on 'load', (data) ->
  console.log data

# Spawn an object on the canvas
socket.on 'spawn', (data) ->
  console.log data
  
# Move an object across the canvas
socket.on 'move', (obj) ->
  console.log obj
  console.log obj.loc