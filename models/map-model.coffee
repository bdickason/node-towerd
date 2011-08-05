cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

# Initialize DB
db = mongoose.connect cfg.DB

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

MapSchema = new Schema {
  name: { type: String, required: true },
  id: { type: String, required: true, unique: true },
  active: { type: Number, default: 1 },
  theme: { type: String, default: 'Water' },
  mobs: [ { type: Number } ],  # A map can have many mobs
}

mongoose.model 'Maps', MapSchema
module.exports = db.model 'Maps' 