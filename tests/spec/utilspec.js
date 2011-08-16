(function() {
  /* Utilities Tests */  var App, Grid, basedir;
  basedir = '../../';
  App = require(basedir + 'app.js');
  Grid = (require(basedir + 'controllers/utils/grid.js')).Grid;
  describe('2d Grid utils/grid.js', function() {
    beforeEach(function() {
      this.size = 10;
      return this.grid = new Grid(this.size);
    });
    it('Creates a 10x10 grid', function() {
      expect(this.grid).toBeDefined();
      expect(this.grid.h).toEqual(this.size);
      return expect(this.grid.w).toEqual(this.size);
    });
    it('Populates with 0s', function() {
      return this.grid.get(1, 1, function(res) {
        return expect(res).toEqual(0);
      });
    });
    it('Converts to a String', function() {
      return this.grid.toString(function(res) {
        expect(res).toBeDefined();
        return expect(res).toEqual('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0');
      });
    });
    return it('Sets 1,1 to a monster', function() {
      this.grid.set(1, 1, 'm', function() {});
      return this.grid.get(1, 1, function(res) {
        return expect(res).toEqual('m');
      });
    });
  });
}).call(this);
