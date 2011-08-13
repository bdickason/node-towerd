### Simple Mongoose DB object ###
# Pulled out of /app.js to encourage modularity (and so tests didn't force me to require 'app' or pass app around)

mongoose = require 'mongoose'
cfg = require '../config/config.js' # contains db info

exports.db = mongoose.connect cfg.DB, (err) ->
  if err
    logger.log 'error', err
  
mongoose.connection.on 'open', ->
  logger.info 'Mongo is connected!'
  ### Wipe the DB on restart ###
  truncate()
  
truncate = () ->
  for _, model of db.models
    m = db.model Object.keys(model)[0]
    m.find {}, (err, docs) ->
      console.log 'removing doc: ' + docs
      doc.remove() for doc in docs

