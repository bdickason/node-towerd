(function() {
  /* Grid.js - Create a 2d grid for the game board */  var Grid;
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
    Grid.prototype.set = function(x, y, value, callback) {
      if (this.isInGrid(x, y)) {
        return this.grid[x][y] = value;
      }
    };
    Grid.prototype.get = function(x, y, callback) {
      if (this.isInGrid(x, y)) {
        return callback(this.grid[x][y]);
      }
    };
    Grid.prototype.toString = function(callback) {
      return callback(this.grid.toString());
    };
    /* toJSON: (callback) ->
      callback { grid: @grid, w: @w, h: @h } */
    Grid.prototype.isInGrid = function(x, y) {
      if (x >= 0 && x <= this.w && y >= 0 && y <= this.h) {
        return true;
      } else {
        return false;
      }
    };
    return Grid;
  })();
}).call(this);
