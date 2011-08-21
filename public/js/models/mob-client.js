(function() {
  /* Mob client-side code */  $(function() {
    return window.Mob = (function() {
      function Mob(data) {
        this.uid = data.uid, this.x = data.x, this.y = data.y, this.dx = data.dx, this.dy = data.dy, this.speed = data.speed, this.maxHP = data.maxHP, this.curHP = data.curHP, this.symbol = data.symbol;
        this.type = 'mob';
        this.layer = 'fg';
      }
      Mob.prototype.move = function(mobdata) {
        if (this.curHP > 0) {
          return this.dx = mobdata.dx, this.dy = mobdata.dy, this.speed = mobdata.speed, mobdata;
        }
      };
      Mob.prototype.die = function(mobdata) {
        this.x = mobdata.x, this.y = mobdata.y, this.dx = mobdata.dx, this.dy = mobdata.dy, this.curHP = mobdata.curHP, this.maxHP = mobdata.maxHP;
        return this.symbol = '*';
      };
      Mob.prototype.update = function(elapsed) {
        var distance;
        distance = (this.speed / 1000) * elapsed * 1.71;
        this.x = this.x + (this.dx * distance);
        return this.y = this.y + (this.dy * distance);
      };
      Mob.prototype.pause = function() {
        this.dx = 0;
        return this.dy = 0;
      };
      Mob.prototype.getLoc = function(loc) {
        return loc * squarewidth;
      };
      return Mob;
    })();
  });
}).call(this);
