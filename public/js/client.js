(function() {
  var socket;
  socket = io.connect('http://localhost');
  socket.on('test', function(data) {
    console.log(data);
    return socket.emit('my other event', {
      my: 'data'
    });
  });
}).call(this);
