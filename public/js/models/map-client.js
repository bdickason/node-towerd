(function() {
  /* Map (grid) client-side code */  $(function() {
    return window.Map = (function() {
      function Map(data) {
        this.uid = data.uid, this.size = data.size, this.end_x = data.end_x, this.end_y = data.end_y;
        this.type = 'map';
        this.layer = 'bg';
      }
      Map.prototype.getLoc = function(loc) {
        return loc * squarewidth;
      };
      return Map;
    })();
  });
}).call(this);
