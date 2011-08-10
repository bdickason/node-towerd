(function() {
  var ObjectId, Schema, UserSchema, cfg, db, mongoose;
  cfg = require('../config/config.js');
  mongoose = require('mongoose');
  db = mongoose.connect(cfg.DB, function(err) {
    if (err) {
      return logger.log('error', err);
    }
  });
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
