(function() {
  var socket;
  socket = io.connect('http://localhost');
  /* Game Events */
  socket.on('load', function(type, obj) {
    return console.log(obj);
  });
  socket.on('spawn', function(type, obj) {
    return console.log(obj);
  });
  socket.on('move', function(type, obj) {
    return console.log(obj);
  });
}).call(this);
