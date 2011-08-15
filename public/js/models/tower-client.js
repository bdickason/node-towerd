(function() {
  /* Tower client-side code */  $(function() {
    return window.Tower = (function() {
      function Tower(data) {
        this.uid = data.uid, this.type = data.type, this.symbol = data.symbol, this.damage = data.damage, this.loc = data.loc;
      }
      Tower.prototype.draw = function(context) {
        var loc;
        loc = [];
        loc[0] = this.getLoc(this.loc[0]);
        loc[1] = this.getLoc(this.loc[1]);
        context.font = '40pt Pictos';
        return context.fillText(this.symbol, loc[0] + 2, loc[1] - 10);
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
      return Tower;
    })();
  });
}).call(this);
