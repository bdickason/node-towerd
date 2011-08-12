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
  socket.on('move', function(data) {
    return console.log(data.obj.loc);
  });
  $(function() {
    return $('#start').click(function() {
      console.log('test');
      socket.emit('start', {});
      return $('#start').html('Game started').unbind('click');
    });
  });
}).call(this);
