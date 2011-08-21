(function() {
  /* Tower client-side code */  $(function() {
    return window.Tower = (function() {
      function Tower(data) {
        var x, y;
        this.uid = data.uid, this.type = data.type, this.symbol = data.symbol, this.damage = data.damage, this.x = data.x, this.y = data.y;
        this.layer = 'fg';
        x = (this.getLoc(data.x)) + (squarewidth / 2);
        y = (this.getLoc(data.y)) - (squarewidth / 2);
        this.line = {
          x: x,
          y: y,
          length: 32,
          angle: 0
        };
      }
      Tower.prototype.fire = function() {
        var bullet, i, random_offset, speed, _results;
        if (bullets.length < 20) {
          _results = [];
          for (i = 0; i <= 5; i++) {
            bullet = new Bullet(this.line.end_x, this.line.end_y, 2);
            random_offset = Math.random() * 1 - .5;
            speed = Math.random() * 15 + 3;
            bullet.vx = speed * Math.cos(this.line.angle + random_offset);
            _results.push(bullet.vy = speed * Math.sin(this.line.angle + random_offset));
          }
          return _results;
        }
      };
      Tower.prototype.update = function() {
        /* Find closest mob and lock on */        var bullet, closest, triangle_x, triangle_y, _i, _len, _results;
        closest = this.findClosest();
        if (closest) {
          triangle_x = (this.getLoc(closest.x)) - this.line.x;
          triangle_y = (this.getLoc(closest.y)) - this.line.y;
          this.line.angle = Math.atan2(triangle_y, triangle_x);
          this.line.end_x = this.line.x + this.line.length * Math.cos(this.line.angle);
          this.line.end_y = this.line.y + this.line.length * Math.sin(this.line.angle);
        }
        _results = [];
        for (_i = 0, _len = bullets.length; _i < _len; _i++) {
          bullet = bullets[_i];
          bullet.x += bullet.vx;
          bullet.y += bullet.vy;
          bullet.vy += .1;
          bullet.vx *= .999;
          bullet.vy *= .99;
          _results.push(bullet.x % fg_canvas.width !== bullet.x ? bullet.remove() : bullet.x >= fg_canvas.height ? (bullet.vy = -Math.abs(bullet.vy), bullet.vy *= .7, Math.abs(bullet.vy < 1 && Math.abs(bullet.vx < 1)) ? bullet.remove() : void 0) : void 0);
        }
        return _results;
      };
      Tower.prototype.getLoc = function(loc) {
        return loc * squarewidth;
      };
      Tower.prototype.findClosest = function() {
        var closest, closest_distance, distance, mob, _i, _len;
        closest = null;
        closest_distance = 9999999;
        for (_i = 0, _len = mobs.length; _i < _len; _i++) {
          mob = mobs[_i];
          distance = this.square(this.x - mob.x) + this.square(this.y - mob.y);
          if (distance < closest_distance) {
            closest = mob;
            closest_distance = distance;
          }
        }
        return closest;
      };
      Tower.prototype.square = function(num) {
        return num * num;
      };
      return Tower;
    })();
  });
}).call(this);
