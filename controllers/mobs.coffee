cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
EventEmitter = (require 'events').EventEmitter

# Models
mobModel = require '../models/mob-model.js'

exports.Mob = class Mob extends EventEmitter
  constructor: (name) ->
    name = name.toLowerCase()   # In case someone throws in some weird name
    logger.info 'Loading mob: ' + name
    toLoad = (require '../data/mobs/' + name + '.js').mob
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this mob
    @id = toLoad.id
    @name = toLoad.name
    @class = toLoad.class
    @active = toLoad.active
    @speed = toLoad.speed
    @maxHP = toLoad.maxHP
    @symbol = toLoad.symbol
    @loc = [null, null]  # Hasn't been spawned yet, so position is null
    @curHP = toLoad.curHP
    
    ### Event Emitters ###
    self = @
    world.on 'gameLoop', ->
      self.move 1, 1, (json) ->
    world.on 'load', (type, obj) ->
      if type == 'tower'
        obj.on 'fire', (uid, damage) ->
          if self.uid == uid
            # Holy shit, the shot was fired at me!
            self.hit(damage)
          
  spawn: (loc, callback) ->
    @curHP = @maxHP # Always spawn with full life (for now!)
    @loc = loc
    @emit 'spawn', 'mob', @loc 
    logger.info 'Spawning mob [' + @id + '] at (' + @loc + ') with UID: ' + @uid
    @save ->
   
  hit: (damage) ->
    @curHP = @curHP - damage
    if @curHP > 0
      logger.info "MOB #{@uid} [#{@curHP}/#{@maxHP}] was hit for #{damage}"
      @emit 'hit', @curHP 
    else
      # mob is dead!
      logger.info "MOB [#{ @uid }] is dead!"
      @emit 'die', @curHP
  
  move: (X, Y, callback) ->
    oldloc = @loc
    @loc = [@loc[0] + X, @loc[1] + Y]
    newloc = @loc
    self = @

    mobModel.find { uid: @uid }, (err, mob) ->
      if(err)
        logger.error 'Error finding mob: {@uid} ' + err
      else
        mob[0].loc = newloc
        mob[0].save (err) ->
          if (err)
            logger.warn 'Error saving mob: {@uid} ' + err
          else
            self.emit 'move', 'mob', oldloc, newloc
            logger.info 'MOB ' + self.uid + ' [' + self.id + '] moved to (' + self.loc[0] + ',' + self.loc[1] + ')'

  save: (callback) ->
    # Save to DB
    newmob = new mobModel ( { uid: @uid, id: @id, name: @name, class: @class, speed: @speed, maxHP: @maxHP, curHP: @curHP, loc: @loc } )
    newmob.save (err, saved) ->
      if err
        logger.error 'Error saving: ' + err
    
  toString: (callback) ->
    output = 'MOB ' + @uid + ' [' + @id + ']  loc: (' + @loc[0] + ', ' + @loc[1] + ')  HP: ' + @curHP + '/' + @maxHP
    callback output