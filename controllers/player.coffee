cfg = require '../config/config.js'    # contains API keys, etc.
EventEmitter = (require 'events').EventEmitter

# Models

exports.Player = class Player extends EventEmitter
  constructor: (uid, world) ->
    @type = 'player'

    @uid = uid  # uid is the player's session ID to make things easier
    @name = 'Bobbin Threadbare'
    @active = 1
