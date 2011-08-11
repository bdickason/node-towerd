(function() {
  /* Mob Tests */  var App, Obj, World, basedir;
  basedir = '../../';
  App = require(basedir + 'app.js');
  World = (require(basedir + 'world.js')).World;
  Obj = (require(basedir + 'controllers/utils/object.js')).Obj;
  describe('World world.js', function() {
    beforeEach(function() {
      global.world = new Obj;
      return this.world = new World;
    });
    return it('Loads some stuff', function() {
      return expect(this.world).toBeDefined();
    });
  });
}).call(this);
