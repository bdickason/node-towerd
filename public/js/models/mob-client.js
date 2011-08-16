(function() {
  /* Mob client-side code */  $(function() {
    return window.Mob = (function() {
      function Mob(data) {
        this.moveConst = 1.6;
        this.uid = data.uid, this.loc = data.loc, this.dx = data.dx, this.dy = data.dy, this.speed = data.speed, this.maxHP = data.maxHP, this.curHP = data.curHP, this.symbol = data.symbol;
      }
      Mob.prototype.move = function(mobdata) {
        return this.loc = mobdata.loc, this.dx = mobdata.dx, this.dy = mobdata.dy, this.speed = mobdata.speed, mobdata;
      };
      Mob.prototype.draw = function(context) {
        var loc;
        this.loc[0] = this.loc[0] + (this.dx * this.speed * this.moveConst / FPS);
        this.loc[1] = this.loc[1] + (this.dx * this.speed * this.moveConst / FPS);
        context.fillStyle = '#000';
        loc = [];
        loc[0] = this.getLoc(this.loc[0]);
        loc[1] = this.getLoc(this.loc[1]);
        context.font = '40pt Pictos';
        return context.fillText(this.symbol, loc[0] + 2, loc[1] - 10);
      };
      Mob.prototype.getLoc = function(loc) {
        if (typeof loc === 'number') {
          return (loc * squarewidth) + 0.5;
        }
      };
      return Mob;
    })();
  });
}).call(this);
