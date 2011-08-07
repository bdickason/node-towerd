socket = io.connect 'http://localhost'

socket.on 'test', (data) ->
  console.log data
  socket.emit 'my other event', my: 'data'
  