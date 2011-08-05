(function() {
  var User, Users, cfg, db, mongoose;
  mongoose = require('mongoose');
  cfg = require('../config/config.js');
  db = mongoose.connect(cfg.DB);
  User = require('../models/user-model.js');
  exports.Users = Users = (function() {
    function Users() {}
    Users.prototype.get = function(id, callback) {
      var query;
      query = {};
      if (id !== null) {
        query = {
          'id': id
        };
      }
      return User.find(query, function(err, user) {
        if (err) {
          return console.log('Error Retrieving: ' + err);
        } else {
          return callback(user);
        }
      });
    };
    Users.prototype.addUser = function(id, name, callback) {
      var newuser;
      newuser = new User({
        'id': id,
        'name': name
      });
      return newuser.save(function(err, user_saved) {
        if (err) {
          return console.log('Error Saving: ' + err);
        } else {
          return console.log('Saved: ' + newuser);
        }
      });
    };
    return Users;
  })();
}).call(this);
