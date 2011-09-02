cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
EventEmitter = (require 'events').EventEmitter

# Models
mobModel = require '../models/mob-model.js'

exports.Mob = class Mob extends EventEmitter
  constructor: (name, world) ->
    world  # Temporary hack so mobs can get positions from the maps in the given world
    @type = 'mob' # So other objects know I'm a mob
    name = name.toLowerCase()   # In case someone throws in some weird name
    logger.info 'Loading mob: ' + name
    toLoad = (require '../data/mobs/' + name + '.js').mob
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this mob    

    @x = null # Hasn't been spawned yet, so position is null
    @y = null
    { @dx, @dy } = 0 # Mob will be stationary when spawned

    { id: @id, x: @x, y: @y, name: @name, class: @class, active: @active, speed: @speed, maxHP: @maxHP, curHP: @curHP, symbol: @symbol } = toLoad

    @emit 'load'
    
    ### Event Emitters ###
    world.on 'gameLoop', =>
      @move world, (json) ->
      
    world.on 'fire', (obj, target) =>
      if obj.type == 'tower'
        if @uid == target.uid.valueOf()
          # Holy shit, the shot was fired at me!
          @hit(obj.damage)
          
  spawn: (x, y, dx, dy, end_x, end_y, callback) ->
    @curHP = @maxHP # Always spawn with full life (for now!)
    { @x, @y, @dx, @dy, @end_x, @end_y } = { x, y, dx, dy, end_x, end_y }
    
    @emit 'spawn'
    logger.info 'Spawning mob [' + @id + '] at (' + @loc + ') with UID: ' + @uid
    @save ->
   
  hit: (damage) ->
    if @curHP > 0 # Make sure mob isn't dead!
      @curHP = @curHP - damage
      if @curHP > 0
        logger.info "MOB #{@uid} [#{@curHP}/#{@maxHP}] was hit for #{damage}"
        @emit 'hit'
      else
        # mob is dead!
        logger.info "MOB [#{ @uid }] is dead!"
        @die()
  
  move: (world, callback) ->
    if @curHP > 0 # Make sure mob isn't dead!    
      old_x = @x
      old_y = @y

      # Calculate new path (using astar)
      world.maps[0].getPath @x, @y, @end_x, @end_y, (path) =>
      
        # Get first path step
        next = path[0]
        if next
          # Mob reached its destination
          @getStep next, (res) =>
        
            # set dx, dy towards path step
            @dx = res.x
            @dy = res.y
    
            # increment x and y
            @x += @dx * @speed
            @y += @dy * @speed
            new_x = @x
            new_y = @y
    
            mobModel.find { uid: @uid }, (err, mob) =>
              if(err)
                logger.error 'Error finding mob: {@uid} ' + err
              else 
                mob[0].x = new_x
                mob[0].y = new_y
                mob[0].save (err) =>
                  if (err)
                    logger.warn 'Error saving mob: {@uid} ' + err
                  else
                    @emit 'move', old_x, old_y
                    logger.info 'MOB ' + @uid + ' [' + @id + '] moved to (' + @x + ',' + @y + ')'
        else
          # Destination reached, don't do crap!
          @dx = 0
          @dy = 0
        
          @emit 'move', old_x, old_y

  # Figure out what direction to go next
  getStep: (next, callback) ->
    if next.x > @x
      callback { x: 1, y: 0 }
    else if next.x < @x
      callback { x: -1, y: 0 }
    else if next.y > @y
      callback { x: 0, y: 1 }
    else if next.y < @y
      callback { x: 0, y: -1 }
    else  # Mob didn't move, wtf?!
      callback { x: 0, y: 0 }
  
  # Mob is dead :x
  die: ->
    @dx = 0
    @dy = 0
    @emit 'die'
    
  save: (callback) ->
    # Save to DB
    newmob = new mobModel ( { uid: @uid, id: @id, name: @name, class: @class, speed: @speed, maxHP: @maxHP, curHP: @curHP, x: @x, y: @y} )
    newmob.save (err, saved) ->
      if err
        logger.error 'Error saving: ' + err
    
  showString: (callback) ->
    output = 'MOB ' + @uid + ' [' + @id + ']  loc: (' + @x + ', ' + @y + ')  HP: ' + @curHP + '/' + @maxHP
    callback output