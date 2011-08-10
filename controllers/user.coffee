mongoose = require 'mongoose'
cfg = require '../config/config.js'    # contains API keys, etc.

# Initialize DB
db = mongoose.connect cfg.DB

# Models
User = require '../models/user-model.js'

exports.Users = class Users
  get: (id, callback) ->
    query = { }
    if id != null
      query = { 'id': id } # id is set, return a single user
    
    User.find query, (err, user) ->
      if err
        logger.error 'Error Retrieving: ' + err        
      else
        callback user

  # Add a user by Goodreads ID
  addUser: (id, name, callback) ->
    newuser = new User { 'id': id, 'name': name}
    newuser.save (err, user_saved) ->
      if err
        logger.warning 'Error Saving: ' + err
      else
        logger.info 'Saved: ' + newuser