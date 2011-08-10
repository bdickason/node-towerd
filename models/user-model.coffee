cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

# Initialize DB
db = mongoose.connect cfg.DB, (err) ->
  if err
    logger.log 'error', err

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

UserSchema = new Schema {
  name : { type: String, required: true },
  id : { type: Number, required: true, unique: true },
  active : { type: Number, default: 1 },
}

mongoose.model 'User', UserSchema
module.exports = db.model 'User'