(function() {
  var ObjectId, Schema, UserSchema, cfg, mongoose;
  cfg = require('../config/config.js');
  mongoose = require('mongoose');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  UserSchema = new Schema({
    name: {
      type: String,
      required: true
    },
    id: {
      type: Number,
      required: true,
      unique: true
    },
    active: {
      type: Number,
      "default": 1
    }
  });
  mongoose.model('User', UserSchema);
  module.exports = db.model('User');
}).call(this);
