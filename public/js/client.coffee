socket = io.connect 'http://localhost'

### Game Events ###

# Load an object's resources into memory
socket.on 'load', (type, obj) ->
  console.log obj

# Spawn an object on the canvas
socket.on 'spawn', (type, obj) ->
  console.log obj
  
# Move an object across the canvas
socket.on 'move', (type, obj) ->
  console.log obj