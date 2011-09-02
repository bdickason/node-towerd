### Player client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /controllers/player-model for defintion

$ ->
  class window.Player
    constructor: (data) ->      
      @type = 'player'

      @pooping = false  # Hopefully the player is not pooping right now