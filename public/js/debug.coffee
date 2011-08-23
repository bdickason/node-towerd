### Server-side Debug/Monitoring ###

# Real time reports on everything going on server-side
# Usage: http://your_host/debug

$ ->
  
  initialized = 0
  socket = io.connect 'http://localhost'
  
  socket.on 'init', (data) ->
    console.log 'Init event'
    setInterval ->
      socket.emit 'debug', {}
    , 1000
  
  socket.on 'debug', (data) ->
    spit data

  socket.on 'fire', (data) ->
    towerFire data
  
  spit = (data) ->
    # Process debug data and hydrate jade template
    # Map - there's only one!
    map = data.map
    if $("#maps ##{map.uid}").length <= 0
      # Doesn't exist, gotta append it!
      $('#maps').append($("<div id=#{map.uid}>").append("<header class='name'></header><div class='uid'></div><div class='size'></div>"))
    
    $("##{map.uid} .name").html("#{map.name}")
    $("##{map.uid} .uid").html("uid: #{map.uid}")
    $("##{map.uid} .size").html("size: #{map.size}")

    # Towers
    for tower in data.towers
      if $("#towers ##{tower.uid}").length <= 0
        # Doesn't exist, gotta append it!
        $('#towers').append($("<div id=#{tower.uid}>").append("<header class='name'></header><div class='uid'></div><div class='damage'></div><div class='fired'"))

      $("##{tower.uid} .name").html("#{tower.name}")
      $("##{tower.uid} .uid").html("uid: #{tower.uid}")
      $("##{tower.uid} .damage").html("dmg: #{tower.damage}")
      
      # Tower Fire event

      
    # Mobs
    for mob in data.mobs
      console.log mob
      if $("#mobs ##{mob.uid}").length <= 0
        # Doesn't exist, gotta append it!
        $('#mobs').append($("<div id=#{mob.uid}>").append("<header class='name'></header><div class='uid'></div><div class='HP'></div>"))
      
      
      $("##{mob.uid} .name").html("#{mob.name}")
      $("##{mob.uid} .uid").html("uid: #{mob.uid}")
      $("##{mob.uid} .HP").html("HP: [#{mob.curHP}/#{mob.maxHP}]")
      # Mob Hit event

        
      
      # Mob Death event
  towerFire = (data) ->
    $("##{tower.uid} .fired").fadeIn('slow', ->
      $("##{tower.uid} .fired}").html("Fired!").fadeIn 'fast'
    )