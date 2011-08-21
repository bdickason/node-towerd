(function() {
  /* Map (grid) client-side code */  $(function() {
    return window.Map = (function() {
      function Map(data) {
        this.uid = data.uid, this.size = data.size, this.end_x = data.end_x, this.end_y = data.end_y;
        this.draw(bg_ctx);
      }
      Map.prototype.draw = function(context) {
        var x, _ref, _step;
        for (x = 0, _ref = this.size, _step = 1; 0 <= _ref ? x <= _ref : x >= _ref; x += _step) {
          context.moveTo(this.getLoc(x), this.getLoc(0));
          context.lineTo(this.getLoc(x), this.getLoc(this.size));
          context.moveTo(this.getLoc(0), this.getLoc(x));
          context.lineTo(this.getLoc(this.size), this.getLoc(x));
        }
        context.strokeStyle = '#000';
        context.stroke();
        context.fillStyle = '#f00';
        context.fillRect(this.getLoc(this.end_x), this.getLoc(this.end_y), squarewidth, squarewidth);
        return console.log('Filling rect: ' + this.end_x + ' ' + this.end_y);
      };
      Map.prototype.getLoc = function(loc) {
        return loc * squarewidth;
      };
      return Map;
    })();
  });
}).call(this);
