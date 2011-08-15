(function() {
  /* Map (grid) client-side code */  $(function() {
    return window.Map = (function() {
      function Map(data) {
        this.uid = data.uid, this.size = data.size;
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
        return context.stroke();
      };
      Map.prototype.getLoc = function(loc) {
        if (typeof loc === 'number') {
          return (loc * squarewidth) + 0.5;
        }
      };
      return Map;
    })();
  });
}).call(this);
