(function() {
  var MobSchema, ObjectId, Schema, cfg, mongoose;
  cfg = require('../config/config.js');
  mongoose = require('mongoose');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  MobSchema = new Schema({
    uid: {
      type: Number,
      unique: true
    },
    name: {
      type: String,
      required: true
    },
    id: {
      type: String
    },
    "class": {
      type: String,
      "default": 'Warrior'
    },
    active: {
      type: Number,
      "default": 1
    },
    symbol: {
      type: String,
      "default": 'W'
    },
    dx: {
      type: Number,
      "default": 0
    },
    dy: {
      type: Number,
      "default": 0
    },
    speed: {
      type: Number,
      "default": 1
    },
    maxHP: {
      type: Number
    },
    curHP: {
      type: Number
    },
    loc: [Number]
  });
  MobSchema.index({
    loc: '2d'
  });
  mongoose.model('Mobs', MobSchema);
  module.exports = db.model('Mobs');
  module.exports;
}).call(this);
