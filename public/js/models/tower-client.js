(function() {
  /* Tower client-side code */  $(function() {
    return window.Tower = (function() {
      function Tower(data) {
        var x, y;
        this.uid = data.uid, this.type = data.type, this.symbol = data.symbol, this.damage = data.damage, this.loc = data.loc;
        x = (this.getLoc(data.loc[0])) + (squarewidth / 2);
        y = (this.getLoc(data.loc[1])) - (squarewidth / 2);
        this.line = {
          x: x,
          y: y,
          length: 32,
          angle: 0
        };
      }
      Tower.prototype.draw = function(context) {
        /* Draw a tower on the map */        var closest, loc, new_x, new_y, triangle_x, triangle_y;
        loc = [];
        loc[0] = this.getLoc(this.loc[0]);
        loc[1] = this.getLoc(this.loc[1]);
        context.font = '40pt Pictos';
        context.fillText(this.symbol, loc[0] + 2, loc[1] - 10);
        /* Draw the gun */
        closest = this.findClosest();
        triangle_x = (this.getLoc(closest.loc[0])) - this.line.x;
        triangle_y = (this.getLoc(closest.loc[1])) - this.line.y;
        this.line.angle = Math.atan2(triangle_y, triangle_x);
        new_x = this.line.x + this.line.length * Math.cos(this.line.angle);
        new_y = this.line.y + this.line.length * Math.sin(this.line.angle);
        context.strokeStyle = '#f00';
        context.lineWidth = 3;
        context.beginPath();
        context.moveTo(this.line.x, this.line.y);
        context.lineTo(new_x, new_y);
        context.stroke();
        return console.log('X: ' + new_x + ' Y: ' + new_y);
      };
      Tower.prototype.drawFire = function(context, mob) {
        var loc;
        loc = [];
        loc[0] = this.getLoc(mob.loc[0]);
        loc[1] = this.getLoc(mob.loc[1]);
        context.fillStyle = '#F00';
        context.font = '20pt Georgia';
        return context.fillText('-' + this.damage, loc[0] + 5, loc[1] - 20);
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
          distance = this.square(this.loc[0] - mob.loc[0]) + this.square(this.loc[1] - mob.loc[1]);
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
