### Map (grid) client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/map-model for defintion
$ -> 
  class window.Map
    constructor: (data) ->
      { @uid, @size, @end_x, @end_y } = data
      @type = 'map'
      @layer = 'bg' # The map should render to the background layer

    getLoc: (loc) ->
      return (loc*squarewidth)