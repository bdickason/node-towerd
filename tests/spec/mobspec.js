(function() {
  /* Mob Tests */  var App, Mob, MobModel, Obj, basedir;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  basedir = '../../';
  App = require(basedir + 'app.js');
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
      this.symbol = '%';
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
      return MobModel.find({
        id: this.id
      }, __bind(function(err, res) {
        return expect(res[0].name).toEqual(this.name);
      }, this));
    });
    it('Spawns itself on the map at 2, 3', function() {
      this.mob.on('spawn', __bind(function(type, x, y, callback) {
        expect(this.mob.x).toEqual(2);
        return expect(this.mob.y).toEqual(3);
      }, this));
      return this.mob.spawn(2, 3, function(callback) {});
    });
    it('Takes damage when hit', function() {
      this.mob.on('hit', __bind(function(callback) {
        return expect(this.mob.curHP).toEqual(47);
      }, this));
      return this.mob.hit(3, function(callback) {});
    });
    it('Takes damage when a tower fires', function() {
      this.mob.on('hit', __bind(function(callback) {
        return expect(this.mob.curHP).toEqual(40);
      }, this));
      this.fakeTower = {
        type: 'tower',
        damage: 10
      };
      this.fakeTarget = {
        uid: this.mob.uid
      };
      return world.emit('fire', this.fakeTower, this.fakeTarget);
    });
    it('Dies when its HP drops to 0', function() {
      this.mob.on('die', __bind(function(curHP, callback) {
        return expect(this.mob.curHP).toBeLessThan(1);
      }, this));
      return this.mob.hit(50, function(callback) {});
    });
    return it('Moves across the map', function() {
      /* Not working atm
      @mob.spawn [0, 0], (callback) ->
      
      @mob.on 'move', (oldLoc) ->
        expect(oldLoc).toEqual [0, 0]
        expect(newLoc).toEqual [1, 1]
      
      @mob.move 1, 1
      */
    });
  });
}).call(this);
