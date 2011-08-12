(function() {
  var socket;
  socket = io.connect('http://localhost');
  /* Game Events */
  socket.on('load', function(data) {
    return console.log(data);
  });
  socket.on('spawn', function(data) {
    return console.log(data);
  });
  socket.on('move', function(obj) {
    console.log(obj);
    return console.log(obj.loc);
  });
  $(function() {
    return $('#start').click(function() {
      console.log('test');
      return socket.emit('start', {});
    });
  });
}).call(this);
