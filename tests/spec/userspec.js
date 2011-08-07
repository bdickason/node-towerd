(function() {
  var Users, basedir, cfg;
  basedir = '../../';
  cfg = require(basedir + 'config/config.js');
  Users = (require(basedir + 'controllers/user.js')).Users;
  describe('Users -  ', function() {
    return it('Returns at least one valid user - /users', function() {
      var user;
      user = new Users;
      user.get(null, function(json) {
        expect(json).toBeDefined();
        expect(json[0].name).toBeDefined();
        expect(json[0].id).toBeDefined();
        return jasmine.asyncSpecDone();
      });
      return jasmine.asyncSpecWait();
    });
  });
  describe('List a single user: /users/:id', function() {
    return it('Returns only one valid user', function() {
      var user;
      user = new Users;
      user.get('0', function(json) {
        expect(json).toBeDefined();
        expect(json[0].name).toBeDefined();
        expect(json[0].id).toBeDefined();
        expect(json[1]).toBeUndefined();
        return jasmine.asyncSpecDone();
      });
      return jasmine.asyncSpecWait();
    });
  });
}).call(this);
