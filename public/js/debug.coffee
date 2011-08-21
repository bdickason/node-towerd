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
  
  
  spit = (data) ->
    # Process debug data and hydrate jade template
    # Map - there's only one!
    map = data.map
    if $(".maps ##{map.uid}").length <= 0
      # Doesn't exist, gotta append it!
      $('.maps').append($("<div id=#{map.uid}>").append("<div class='name'></div><div class='uid'></div><div class='size'></div>"))
    
    $("##{map.uid} .name").html("name: #{map.name}")
    $("##{map.uid} .uid").html("uid: #{map.uid}")
    $("##{map.uid} .size").html("size: #{map.size}")

    # Towers
    for tower in data.towers
      if $(".towers ##{tower.uid}").length <= 0
        # Doesn't exist, gotta append it!
        $('.towers').append($("<div id=#{tower.uid}>").append("<div class='name'></div><div class='uid'></div><div class='damage'></div>"))

      $("##{tower.uid} .name").html("name: #{tower.name}")
      $("##{tower.uid} .uid").html("uid: #{tower.uid}")
      $("##{tower.uid} .damage").html("dmg: #{tower.damage}")
      
    # Mobs
    for mob in data.mobs
      console.log mob
      if $(".mobs ##{mob.uid}").length <= 0
        # Doesn't exist, gotta append it!
        $('.mobs').append($("<div id=#{mob.uid}>").append("<div class='name'></div><div class='uid'></div><div class='HP'></div>"))

      $("##{mob.uid} .name").html("name: #{mob.name}")
      $("##{mob.uid} .uid").html("uid: #{mob.uid}")
      $("##{mob.uid} .HP").html("HP: [#{mob.curHP}/#{mob.maxHP}]")