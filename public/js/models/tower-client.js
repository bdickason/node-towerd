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
        return context.stroke();
      };
      Tower.prototype.drawFire = function(context, mob) {
        var _x, _y;
        _x = this.getLoc(mob.x);
        _y = this.getLoc(mob.y);
        context.fillStyle = '#F00';
        context.font = '20pt Georgia';
        return context.fillText('-' + this.damage, _x + 5, _y - 20);
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
