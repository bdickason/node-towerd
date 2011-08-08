
A simple Tower D game written in NodeJS

Event Model:
In order to process a ton of stuff that's going on, I've utilized a simple event-based model controlled by the 'world' (found in /world.js). When you start the server, it automagically instantiates a new 'world' and makes it global.

World is responsible for loading the initial objects into the world and from there, each object emits and listens to its own set of events.

The basic structure goes something like this:
![Event Model] (http://i51.tinypic.com/34owjv7.png)

Here's an example of when a mob moves
![Event Example] (http://i51.tinypic.com/2zso1o5.png)

I'll let the code do the talking:
**world.js**
`@maps.push new map json.map
    @emit 'load', 'map', _map for _map in @maps
    # any class listening to world.on 'load' now has access to _map`
  

`@mobs[0].spawn [0, 0]
  # a mob will now emit a spawn event, causing all others`

**towers.js**
`world.on 'load', (type, obj) ->
      # Ignore all other towers and maps
      if type == 'mob'
        # Check targets each time a mob moves        
        obj.on 'move', (loc) ->
          self.checkTargets (res) ->`
             ## Shoot some shit!~

I'm still exploring this pattern so it may change dramatically, but it's the best I've got for now :D

Inspired by:
http://stackoverflow.com/questions/6969187/in-a-nodejs-game-with-each-object-as-a-class-how-should-events-be-treated/6972169#6972169

http://pragprog.com/magazines/2011-08/decouple-your-apps-with-eventdriven-coffeescript