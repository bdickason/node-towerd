### Client-side class - bullet ###

# Currently shot by a minigun tower, may be reused in the future
$ ->
  class window.Bullet
    constructor: (x, y, r) ->
      { @x, @y, @r } = {x, y, r}
      @vx = 0
      @vy = 0
      bullets.push @

    draw: (context) ->
      context.translate @x, @y
      context.fillStyle = '#fb0'
      context.beginPath()
      context.arc 0, 0, @r, 0, Math.PI * 2, true
      context.closePath()
      context.fill()
    
    remove: ->
      bullets.splice bullets.indexOf @, 1
