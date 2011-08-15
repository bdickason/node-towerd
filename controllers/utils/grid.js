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
    Grid.prototype.set = function(loc, value, callback) {
      if (this.isInGrid(loc)) {
        return this.grid[loc[0]][loc[1]] = value;
      }
    };
    Grid.prototype.get = function(loc, callback) {
      if (this.isInGrid(loc)) {
        return callback(this.grid[loc[0]][loc[1]]);
      }
    };
    Grid.prototype.toString = function(callback) {
      return callback(this.grid.toString());
    };
    /* toJSON: (callback) ->
      callback { grid: @grid, w: @w, h: @h } */
    Grid.prototype.isInGrid = function(loc) {
      if (loc[0] >= 0 && loc[0] <= this.w && loc[1] >= 0 && loc[1] <= this.h) {
        return true;
      } else {
        return false;
      }
    };
    return Grid;
  })();
}).call(this);
