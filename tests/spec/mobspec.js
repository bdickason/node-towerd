(function() {
  /* Mob Tests */  var Mob, MobModel, Obj, basedir;
  basedir = '../../';
  Mob = (require(basedir + 'controllers/mobs.js')).Mob;
  MobModel = require(basedir + 'models/mob-model.js');
  Obj = (require(basedir + 'controllers/utils/object.js')).Obj;
  describe('Mob mobs.js', function() {
    beforeEach(function() {
      global.world = new Obj;
      this.name = 'Warrior';
      this.id = 'warrior';
      this.active = 1;
      this["class"] = 'warrior';
      this.symbol = 'W';
      this.speed = 1;
      this.maxHP = 50;
      return this.mob = new Mob(this.id);
    });
    it('Loads a new mob called Warrior', function() {
      expect(this.mob.id).toEqual(this.id);
      expect(this.mob.name).toEqual(this.name);
      expect(this.mob.active).toEqual(this.active);
      expect(this.mob["class"]).toEqual(this["class"]);
      expect(this.mob.symbol).toEqual(this.symbol);
      expect(this.mob.speed).toEqual(this.speed);
      return expect(this.mob.maxHP).toEqual(this.maxHP);
    });
    it('Saves itself to the DB once loaded', function() {
      var self;
      self = this;
      return MobModel.find({
        id: this.id
      }, function(err, res) {
        return expect(res[0].name).toEqual(self.name);
      });
    });
    it('Spawns itself on the map at 2, 3', function() {
      var self;
      self = this;
      this.mob.on('spawn', function(type, loc, callback) {
        return expect(self.mob.loc).toEqual([2, 3]);
      });
      return this.mob.spawn([2, 3], function(callback) {});
    });
    it('Takes damage when hit', function() {
      var self;
      self = this;
      this.mob.on('hit', function(curHP, callback) {
        return expect(self.mob.curHP).toEqual(47);
      });
      return this.mob.hit(3, function(callback) {});
    });
    it('Dies when its HP drops to 0', function() {
      var self;
      self = this;
      this.mob.on('die', function(curHP, callback) {
        return expect(self.mob.curHP).toBeLessThan(1);
      });
      return this.mob.hit(50, function(callback) {});
    });
    return it('Moves across the map', function() {
      var self;
      self = this;
      this.mob.spawn([0, 0], function(callback) {});
      this.mob.on('move', function(type, oldLoc, newLoc) {
        expect(oldLoc).toEqual([0, 0]);
        return expect(newLoc).toEqual([1, 1]);
      });
      return this.mob.move(1, 1);
    });
  });
}).call(this);
