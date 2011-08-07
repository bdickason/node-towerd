(function() {
  /* Utils.js - Quick utility classes for stuff like:
        -Creating a game grid
        -etc.
  */  var Grid;
  exports.Grid = Grid = (function() {
    function Grid(size) {
      var row, x, y, _ref, _ref2;
      this.grid = [];
      this.w = size;
      this.h = size;
      for (x = _ref = this.w; _ref <= 0 ? x <= 0 : x >= 0; _ref <= 0 ? x++ : x--) {
        row = [];
        for (y = _ref2 = this.h; _ref2 <= 0 ? y <= 0 : y >= 0; _ref2 <= 0 ? y++ : y--) {
          row.push(0);
        }
        this.grid.push(row);
      }
    }
    Grid.prototype.set = function(loc, value, callback) {
      console.log('loc: ' + loc);
      console.log('value: ' + value);
      return this.grid[loc[0]][loc[1]] = value;
    };
    Grid.prototype.get = function(loc, callback) {
      return callback(this.grid[loc[0]][loc[1]]);
    };
    Grid.prototype.toString = function(callback) {
      console.log('hit this');
      return callback(this.grid.toString());
    };
    return Grid;
  })();
}).call(this);
