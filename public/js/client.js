(function() {
  $(function() {
    /* Config Variables */    var draw, socket;
    window.squarewidth = 50;
    window.FPS = 30;
    socket = io.connect('http://localhost');
    /* Game Events */
    socket.on('init', function(data) {
      var mob, tower, _i, _j, _len, _len2, _map, _mobs, _results, _towers;
      console.log('Init event');
      window.mapChanged = 1;
      _map = data.data.map;
      _mobs = data.data.mobs;
      _towers = data.data.towers;
      window.mobs = [];
      window.towers = [];
      window.map = new Map(_map);
      for (_i = 0, _len = _mobs.length; _i < _len; _i++) {
        mob = _mobs[_i];
        mobs.push(new Mob(mob));
      }
      _results = [];
      for (_j = 0, _len2 = _towers.length; _j < _len2; _j++) {
        tower = _towers[_j];
        _results.push(towers.push(new Tower(tower)));
      }
      return _results;
    });
    socket.on('load', function(data) {
      return console.log('Load event');
    });
    socket.on('spawn', function(data) {
      return console.log('Spawn event');
    });
    socket.on('move', function(data) {
      var mob, _i, _len, _results;
      console.log('Move event');
      _results = [];
      for (_i = 0, _len = mobs.length; _i < _len; _i++) {
        mob = mobs[_i];
        if (mob.uid === data.uid) {
          _results.push(mob.move(data));
        }
      }
      return _results;
    });
    socket.on('fire', function(data) {
      console.log('Fire event');
      return console.log(data);
      /*    mob = data.target
      tower = data.obj
      drawFire mob, tower */
    });
    /* Define canvas, etc */
    window.fg_canvas = document.getElementById('game_canvas');
    window.fg_ctx = fg_canvas.getContext('2d');
    window.bg_canvas = document.getElementById('game_background');
    window.bg_ctx = bg_canvas.getContext('2d');
    draw = function() {
      var mob, tower, _i, _j, _len, _len2, _results;
      if (fg_canvas.getContext) {
        fg_ctx.clearRect(0, 0, fg_canvas.width, fg_canvas.height);
        for (_i = 0, _len = towers.length; _i < _len; _i++) {
          tower = towers[_i];
          tower.draw(fg_ctx);
        }
        _results = [];
        for (_j = 0, _len2 = mobs.length; _j < _len2; _j++) {
          mob = mobs[_j];
          _results.push(mob.draw(fg_ctx));
        }
        return _results;
      }
    };
    setInterval(draw, 1000 / FPS);
    /* World Rendering Functions */
    /* on-page actions (clicks, etc) */
    $('#toggle').bind('click', function() {
      if ($(this).attr('class') === 'play') {
        socket.emit('start', {});
        $(this).html('5').attr('class', 'pause');
      } else {
        socket.emit('pause', {});
        $(this).html('4').attr('class', 'play');
      }
      return $('#start').html('Game started').click(function() {
        return socket.emit('pause', {});
      });
    });
    return $('#tower').click(function() {
      return console.log('adding tower');
    });
  });
}).call(this);
