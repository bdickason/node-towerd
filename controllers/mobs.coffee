cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
EventEmitter = (require 'events').EventEmitter

# Models
mobModel = require '../models/mob-model.js'

exports.Mob = class Mob extends EventEmitter
  constructor: (name) ->
    name = name.toLowerCase()   # In case someone throws in some weird name
    console.log 'Loading mob: ' + name
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
        console.log 'listening to ' + obj.uid
        obj.on 'fire', (uid, damage) ->
          console.log 'shots fired captain! uid: ' + uid + ' self.uid: ' + self.uid
          console.log self.uid == uid
          console.log 'shots fired captain! uid: ' + uid + ' self.uid: ' + self.uid
          ### if self.uid == uid
            # Holy shit, the shot was fired at me!
            console.log 'Im hit'
            self.hit(damage) ###
          
  spawn: (loc, callback) ->
    @curHP = @maxHP # Always spawn with full life (for now!)
    @loc = loc
    @emit 'spawn', 'mob', @loc 
    console.log 'Spawning mob [' + @id + '] at (' + @loc + ') with UID: ' + @uid
    @save ->
   
    
  
  hit: (damage) ->
    @curHP = @curHP - damage
    if @curHP > 0
      console.log 'We have a hit! ' + @uid + ' was hit for: ' + damage
      @emit 'hit', @curHP 
    else
      # mob is dead!
      console.log 'you sunk my battleship!'
      @emit 'die', @curHP
  
  move: (X, Y, callback) ->
    oldloc = @loc
    @loc = [@loc[0] + X, @loc[1] + Y]
    newloc = @loc
    self = @

    mobModel.find { uid: @uid }, (err, mob) ->
      if(err)
        console.log 'Error finding mob: {@uid} ' + err
      else
        mob[0].loc = newloc
        mob[0].save (err) ->
          if (err)
            console.log 'Error saving mob: {@uid} ' + err
          else
            self.emit 'move', 'mob', oldloc, newloc
    console.log 'MOB ' + @uid + ' [' + @id + '] moved to (' + @loc[0] + ',' + @loc[1] + ')'

  save: (callback) ->
    # Save to DB
    newmob = new mobModel ( { uid: @uid, id: @id, name: @name, class: @class, speed: @speed, maxHP: @maxHP, curHP: @curHP, loc: @loc } )
    newmob.save (err, saved) ->
      if err
        console.log 'Error saving: ' + err
      else
        console.log 'Saved mob: ' + newmob.uid
    
  toString: (callback) ->
    output = 'MOB ' + @uid + ' [' + @id + ']  loc: (' + @loc[0] + ', ' + @loc[1] + ')  HP: ' + @curHP + '/' + @maxHP
    callback output
    
  defineEmitters: (callback) ->
    world.on 'test', ->