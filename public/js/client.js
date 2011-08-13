(function() {
  var drawGrid, socket;
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
  /* Initialize Canvas */
  drawGrid = function() {
    var canvas, context;
    canvas = document.getElementById('game_canvas');
    context = canvas.getContext('2d');
    context.fillStyle = 'rgb(200,0,0)';
    return context.fillRect(10, 10, 100, 100);
  };
  $(function() {
    var canvas;
    $('#start').click(function() {
      console.log('test');
      socket.emit('start', {});
      return $('#start').html('Game started').unbind('click');
    });
    canvas = document.getElementById('game_canvas');
    console.log('found canvas');
    if (canvas.getContext) {
      return drawGrid();
    }
  });
}).call(this);
