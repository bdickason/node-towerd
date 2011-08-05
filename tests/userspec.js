(function() {
  var Users, cfg;
  cfg = require('../config/config.js');
  Users = (require('../controllers/user.js')).Users;
  describe('List all users: /users', function() {
    return it('Returns at least one valid user', function() {
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
