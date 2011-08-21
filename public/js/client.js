(function() {
  $(function() {
    /* Config Variables */    var draw, game, handleInput, lastUpdate, reverseLoc, socket, update;
    window.squarewidth = 50;
    window.FPS = 30;
    /* Reserved Variables */
    window.bullets = [];
    window.startTime = Date.now();
    window.elapsed = 0;
    lastUpdate = startTime;
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
      switch (data.type) {
        case 'tower':
          console.log('Spawning tower');
          console.log(data);
          return towers.push(new Tower(data));
      }
    });
    socket.on('move', function(data) {
      var mob, _i, _len, _results;
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
      var tower, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = towers.length; _i < _len; _i++) {
        tower = towers[_i];
        if (tower.uid === data.obj.uid) {
          _results.push(tower.fire());
        }
      }
      return _results;
    });
    socket.on('die', function(data) {
      var mob, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = mobs.length; _i < _len; _i++) {
        mob = mobs[_i];
        if (mob.uid === data.uid) {
          _results.push(mob.die(data));
        }
      }
      return _results;
    });
    /* Define canvas, etc */
    window.fg_canvas = document.getElementById('game_canvas');
    window.fg_ctx = fg_canvas.getContext('2d');
    console.log(fg_canvas.offsetLeft);
    console.log(fg_canvas.offsetTop);
    window.bg_canvas = document.getElementById('game_background');
    window.bg_ctx = bg_canvas.getContext('2d');
    game = function() {
      handleInput();
      update();
      return draw();
    };
    handleInput = function() {};
    update = function() {
      var elapsed, mob, now, tower, _i, _j, _len, _len2, _results;
      now = Date.now();
      elapsed = now - lastUpdate;
      lastUpdate = now;
      for (_i = 0, _len = towers.length; _i < _len; _i++) {
        tower = towers[_i];
        tower.update();
      }
      _results = [];
      for (_j = 0, _len2 = mobs.length; _j < _len2; _j++) {
        mob = mobs[_j];
        _results.push(mob.update(elapsed));
      }
      return _results;
    };
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
    /* World Rendering Functions */
    window.gameLoop = setInterval(game, 1000 / FPS);
    /* on-page actions (clicks, etc) */
    $('#toggle').bind('click', function() {
      var mob, _i, _len;
      if ($(this).attr('class') === 'play') {
        window.gameLoop = setInterval(game, 1000 / FPS);
        socket.emit('start', {});
        $(this).html('5').attr('class', 'pause');
      } else {
        clearInterval(gameLoop);
        socket.emit('pause', {});
        for (_i = 0, _len = mobs.length; _i < _len; _i++) {
          mob = mobs[_i];
          mob.pause();
        }
        $(this).html('4').attr('class', 'play');
      }
      return $('#start').html('Game started').click(function() {
        return socket.emit('pause', {});
      });
    });
    $('#game_canvas').click(function(e) {
      return socket.emit('add', 'tower', reverseLoc(e.offsetX), reverseLoc(e.offsetY));
    });
    return reverseLoc = function(loc) {
      return Math.floor(loc / squarewidth);
    };
  });
}).call(this);
