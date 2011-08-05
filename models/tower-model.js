(function() {
  var ObjectId, Schema, TowerSchema, cfg, db, mongoose;
  cfg = require('../config/config.js');
  mongoose = require('mongoose');
  db = mongoose.connect(cfg.DB);
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  TowerSchema = new Schema({
    name: {
      type: String,
      required: true
    },
    id: {
      type: String,
      required: true,
      unique: true
    },
    type: {
      type: String,
      "default": 'Cannon'
    },
    active: {
      type: Number,
      "default": 1
    },
    damage: {
      type: Number
    },
    range: {
      type: Number
    }
  });
  mongoose.model('Towers', TowerSchema);
  module.exports = db.model('Towers');
}).call(this);
