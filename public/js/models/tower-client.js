(function() {
  /* Tower client-side code */  $(function() {
    return window.Tower = (function() {
      function Tower(data) {
        var x, y;
        this.uid = data.uid, this.type = data.type, this.symbol = data.symbol, this.damage = data.damage, this.x = data.x, this.y = data.y;
        x = (this.getLoc(data.x)) + (squarewidth / 2);
        y = (this.getLoc(data.y)) - (squarewidth / 2);
        this.line = {
          x: x,
          y: y,
          length: 32,
          angle: 0
        };
      }
      Tower.prototype.draw = function(context) {
        /* Draw a tower on the map */        var closest, new_x, new_y, triangle_x, triangle_y, _x, _y;
        _x = this.getLoc(this.x);
        _y = this.getLoc(this.y);
        context.font = '40pt Pictos';
        context.fillText(this.symbol, _x + 2, _y - 10);
        /* Draw the gun */
        closest = this.findClosest();
        triangle_x = (this.getLoc(closest.x)) - this.line.x;
        triangle_y = (this.getLoc(closest.y)) - this.line.y;
        this.line.angle = Math.atan2(triangle_y, triangle_x);
        new_x = this.line.x + this.line.length * Math.cos(this.line.angle);
        new_y = this.line.y + this.line.length * Math.sin(this.line.angle);
        context.strokeStyle = '#f00';
        context.lineWidth = 3;
        context.beginPath();
        context.moveTo(this.line.x, this.line.y);
        context.lineTo(new_x, new_y);
        context.stroke();
        return this.drawFire(context);
      };
      Tower.prototype.drawFire = function(context) {
        var bullet, i, random_offset, speed, _i, _len, _results;
        if (bullets.length < 20) {
          for (i = 0; i <= 5; i++) {
            bullet = new Bullet(this.x, this.y, 2);
            random_offset = Math.random() * 1 - .5;
            speed = Math.random() * 15 + 3;
            bullet.vx = speed * Math.cos(this.line.angle + random_offset);
            bullet.vy = speed * Math.sin(this.line.angle + random_offset);
          }
        }
        _results = [];
        for (_i = 0, _len = bullets.length; _i < _len; _i++) {
          bullet = bullets[_i];
          bullet.x += bullet.vx;
          bullet.y += bullet.vy;
          bullet.vy += .1;
          bullet.vx *= .999;
          bullet.vy *= .99;
          if (bullet.x % fg_canvas.width !== bullet.x) {
            bullet.remove();
          } else if (bullet.x >= fg_canvas.height) {
            bullet.vy = -Math.abs(bullet.vy);
            bullet.vy *= .7;
            if (Math.abs(bullet.vy < 1 && Math.abs(bullet.vx < 1))) {
              bullet.remove();
            }
          }
          _results.push(bullet.draw(context));
        }
        return _results;
      };
      Tower.prototype.getLoc = function(loc) {
        if (typeof loc === 'number') {
          return (loc * squarewidth) + 0.5;
        }
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
