### Simple Mongoose DB object ###
# Pulled out of /app.js to encourage modularity (and so tests didn't force me to require 'app' or pass app around)

mongoose = require 'mongoose'
cfg = require '../config/config.js' # contains db info

exports.db = mongoose.connect cfg.DB, (err) ->
  if err
    logger.log 'error', err
  
mongoose.connection.on 'open', ->
  logger.info 'Mongo is connected!'