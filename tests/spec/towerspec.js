(function() {
  /* Tower Tests */  var Mob, MobModel, Obj, Tower, TowerModel, basedir;
  basedir = '../../';
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
      this.damage = 5;
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
      var self;
      self = this;
      return TowerModel.find({
        id: this.id
      }, function(err, res) {
        return expect(res[0].name).toEqual(self.name);
      });
    });
    it('Spawns itself on the map at 5, 4', function() {
      var self;
      self = this;
      this.tower.on('spawn', function(type, loc, callback) {
        return expect(self.tower.loc).toEqual([5, 4]);
      });
      return this.tower.spawn([5, 4], function(callback) {});
    });
    /* TODO - Find a way to gracefully clear the DB before tests run
    it 'Finds no targets when none are in range', ->
      
      # Spawn the tower    
      @tower.spawn [5, 4], (callback) ->      
      
      # Spawn a fake mob
      fakeMob = new Mob 'warrior'
    
      fakeMob.spawn [0, 0], (callback) ->
      
      @tower.checkTargets (res) ->
        expect(res).toEqual []
    */
    return it('Finds targets when one is in range', function() {
      var fakeMob;
      this.tower.spawn([5, 4], function(callback) {});
      fakeMob = new Mob('warrior');
      fakeMob.spawn([5, 5], function(callback) {});
      return this.tower.checkTargets(function(res) {
        return expect(res[0].id).toEqual('warrior');
      });
    });
  });
}).call(this);
