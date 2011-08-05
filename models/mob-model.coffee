cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

# Initialize DB
db = mongoose.connect cfg.DB

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

MobSchema = new Schema {
  name: { type: String, required: true },
  id: { type: Sting, required: true, unique: true },
  class: { type: String, default: 'Warrior' },
  active: { type: Number, default: 1 },
  maxHP: { type: Number },
  currentHP: { type: Number },
}

mongoose.model 'Mobs', MobSchema
module.exports = db.model 'Mobs'