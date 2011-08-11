(function() {
  var App, Users, basedir, cfg;
  basedir = '../../';
  App = require(basedir + 'app.js');
  cfg = require(basedir + 'config/config.js');
  Users = (require(basedir + 'controllers/user.js')).Users;
  /* TODO - Rewrite tests when we integrate users
  describe 'Users - user.js', -> 
    it 'Returns at least one valid user - /users', ->
      user = new Users
      user.get null, (json) ->
        expect(json).toBeDefined()
        expect(json[0].name).toBeDefined()
        expect(json[0].id).toBeDefined()
        jasmine.asyncSpecDone()
      jasmine.asyncSpecWait()
  
  describe 'List a single user: /users/:id', ->
    it 'Returns only one valid user', ->
      user = new Users
      user.get '0', (json) ->
        expect(json).toBeDefined()
        expect(json[0].name).toBeDefined()
        expect(json[0].id).toBeDefined()
        expect(json[1]).toBeUndefined()
        jasmine.asyncSpecDone()
      jasmine.asyncSpecWait()
  */
}).call(this);
