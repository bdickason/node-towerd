cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

# Initialize DB
db = mongoose.connect cfg.DB

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

MobSchema = new Schema {
  name: { type: String, required: true },
  id: { type: String, required: true, unique: true },
  class: { type: String, default: 'Warrior' },
  active: { type: Number, default: 1 },
  speed: { type: Number, default: 1 },
  maxHP: { type: Number },
  curHP: { type: Number },
  X: { type: Number },
  Y: { type: Number }
}

mongoose.model 'Mobs', MobSchema
module.exports = db.model 'Mobs'