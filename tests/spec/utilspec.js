(function() {
  /* Utilities Tests */  var App, Graph, Grid, astar, basedir;
  basedir = '../../';
  App = require(basedir + 'app.js');
  Grid = (require(basedir + 'controllers/utils/grid')).Grid;
  Graph = (require(basedir + 'controllers/utils/graph')).Graph;
  astar = (require(basedir + 'controllers/utils/astar')).astar;
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
  describe('2d Graph utils/graph.js', function() {
    beforeEach(function() {
      this.size = 10;
      return this.graph = new Graph(this.size);
    });
    it('Creates a 10x10 empty grid', function() {
      expect(this.graph).toBeDefined();
      expect(this.graph.toString().length).toEqual(211);
      expect(this.graph.nodes[0][0].isWall()).toBeFalsy();
      expect(this.graph.nodes[9][9].isWall()).toBeFalsy();
      return expect(this.graph.nodes[15]).toBeUndefined();
    });
    return it('Can add a wall to the grid at 3, 6', function() {
      this.graph.nodes[3][6].wall();
      return expect(this.graph.nodes[3][6].isWall()).toBeTruthy();
    });
  });
  describe('A* Pathing utils/astar.js', function() {
    beforeEach(function() {
      this.size = 10;
      return this.graph = new Graph(this.size);
    });
    it('Can path from 0,0 to 4,4', function() {
      var end, hop, start, _i, _len, _ref;
      start = this.graph.nodes[0][0];
      end = this.graph.nodes[4][4];
      this.path = astar.search(this.graph.nodes, start, end);
      _ref = this.path;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hop = _ref[_i];
        this.graph.nodes[hop.x][hop.y].path();
      }
      expect(this.graph.nodes[0][0].isWall()).toBeFalsy();
      expect(this.graph.nodes[4][4].isWall()).toBeFalsy();
      expect(this.graph.nodes[0][0].isPath()).toBeFalsy();
      expect(this.graph.nodes[4][4].isPath()).toBeTruthy();
      return expect(this.graph.nodes[8][9].isPath()).toBeFalsy();
    });
    return it('Can path around a single wall at 2, 2', function() {
      var end, hop, start, wall, _i, _len, _ref;
      start = this.graph.nodes[0][0];
      end = this.graph.nodes[4][4];
      wall = this.graph.nodes[3][4];
      wall.wall();
      this.path = astar.search(this.graph.nodes, start, end);
      _ref = this.path;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hop = _ref[_i];
        this.graph.nodes[hop.x][hop.y].path();
      }
      expect(this.graph.nodes[3][4].isWall()).toBeTruthy();
      expect(this.graph.nodes[0][0].isPath()).toBeFalsy();
      expect(this.graph.nodes[4][4].isPath()).toBeTruthy();
      return expect(this.graph.nodes[8][9].isPath()).toBeFalsy();
    });
  });
}).call(this);
