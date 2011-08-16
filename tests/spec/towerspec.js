(function() {
  /* Tower Tests */  var App, Mob, MobModel, Obj, Tower, TowerModel, basedir;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  basedir = '../../';
  App = require(basedir + 'app.js');
  Tower = (require(basedir + 'controllers/towers.js')).Tower;
  TowerModel = require(basedir + 'models/tower-model.js');
  Mob = (require(basedir + 'controllers/mobs.js')).Mob;
  MobModel = require(basedir + 'models/mob-model.js');
  Obj = (require(basedir + 'controllers/utils/object.js')).Obj;
  describe('Towers towers.js', function() {
    beforeEach(function() {
      global.world = new Obj;
      this.name = 'Cannon Tower';
      this.id = 'cannon';
      this.active = 1;
      this.symbol = 'C';
      this.damage = 10;
      this.range = 2;
      this.fakeMob = new Obj;
      this.fakeMob.symbol = 'm';
      return this.tower = new Tower(this.id);
    });
    it('Loads a new tower called Cannon Tower', function() {
      expect(this.tower.id).toEqual(this.id);
      expect(this.tower.name).toEqual(this.name);
      expect(this.tower.active).toEqual(this.active);
      expect(this.tower.damage).toEqual(this.damage);
      return expect(this.tower.range).toEqual(this.range);
    });
    it('Saves itself to the DB once loaded', function() {
      return TowerModel.find({
        id: this.id
      }, __bind(function(err, res) {
        return expect(res[0].name).toEqual(this.name);
      }, this));
    });
    it('Spawns itself on the map at 5, 4', function() {
      this.tower.on('spawn', __bind(function(type, x, y, callback) {
        expect(this.tower.x).toEqual(5);
        return expect(this.tower.y).toEqual(4);
      }, this));
      return this.tower.spawn(5, 4, function(callback) {});
    });
    it('Finds no targets when none are in range', function() {
      var fakeMob;
      this.tower.spawn(5, 4, function(callback) {});
      fakeMob = new Mob('warrior');
      fakeMob.spawn(0, 0, function(callback) {});
      return this.tower.checkTarget(fakeMob, function(res) {
        return expect(res).toEqual([]);
      });
    });
    return it('Fires on a target when one is in range', function() {
      var fakeMob;
      this.tower.spawn(5, 4, function(callback) {});
      fakeMob = new Mob('warrior');
      fakeMob.spawn(5, 5, function(callback) {});
      return this.tower.checkTarget(fakeMob, function(res) {
        return expect(res.id).toEqual('warrior');
      });
    });
  });
}).call(this);
