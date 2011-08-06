cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

# Initialize DB
db = mongoose.connect cfg.DB

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

TowerSchema = new Schema
  name: { type: String, required: true },
  id: { type: String, required: true, unique: true },
  type: { type: String, default: 'Cannon' },
  active: { type: Number, default: 1 },
  damage: { type: Number },
  range: { type: Number },
  loc: { 
    X: { type: Number, default: null },
    Y: { type: Number, default: null }
  }

# Enable geospatial indexing
TowerSchema.index { location: '2d' }
  
mongoose.model 'Towers', TowerSchema
module.exports = db.model 'Towers'