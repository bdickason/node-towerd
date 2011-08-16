cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

TowerSchema = new Schema
  uid: { type: Number, required: true },
  name: { type: String, required: true },
  id: { type: String, required: true, unique: true },
  type: { type: String, default: 'Cannon' },
  active: { type: Number, default: 1 },
  symbol: { type: String, default: 'C' },
  damage: { type: Number },
  range: { type: Number },
  x: { type: Number },
  y: { type: Number }
  
  
mongoose.model 'Towers', TowerSchema
module.exports = db.model 'Towers'