(function() {
  var MapSchema, ObjectId, Schema, cfg, mongoose;
  cfg = require('../config/config.js');
  mongoose = require('mongoose');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  MapSchema = new Schema({
    name: {
      type: String,
      required: true
    },
    id: {
      type: String,
      required: true,
      unique: true
    },
    active: {
      type: Number,
      "default": 1
    },
    theme: {
      type: String,
      "default": 'Water'
    },
    mobs: [String]
  });
  mongoose.model('Maps', MapSchema);
  module.exports = db.model('Maps');
}).call(this);
