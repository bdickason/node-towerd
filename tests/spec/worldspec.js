(function() {
  /* Mob Tests */  var Obj, World, basedir;
  basedir = '../../';
  World = (require(basedir + 'world.js')).World;
  Obj = (require(basedir + 'controllers/utils/object.js')).Obj;
  describe('Mob mobs.js', function() {
    beforeEach(function() {
      global.world = new Obj;
      return this.world = new World;
    });
    return it('Loads some stuff', function() {
      return expect(this.world).toBeDefined();
    });
  });
}).call(this);
