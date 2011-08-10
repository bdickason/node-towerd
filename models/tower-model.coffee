cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

# Initialize DB
db = mongoose.connect cfg.DB, (err) ->
  if err
    logger.log 'error', err

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

TowerSchema = new Schema
  name: { type: String, required: true },
  id: { type: String, required: true, unique: true },
  type: { type: String, default: 'Cannon' },
  active: { type: Number, default: 1 },
  symbol: { type: String, default: 'C' },
  damage: { type: Number },
  range: { type: Number },
  loc: [ Number ]
  }

# Enable geospatial indexing
TowerSchema.index { loc: '2d' }
  
mongoose.model 'Towers', TowerSchema
module.exports = db.model 'Towers'