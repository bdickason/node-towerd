(function() {
  var Game, maps, mobs;
  maps = (require('./maps')).Maps;
  mobs = (require('./mobs')).Mobs;
  exports.Game = Game = (function() {
    var map, mob;
    function Game() {}
    /* Load the map */
    map = new maps('hiddenvalley');
    console.log(map);
    /* Load the mobs */
    mob = new mobs('warrior');
    mob.spawn(0, 0, 0, function(json) {
      return console.log('Mob: ' + mob);
    });
    mob.move(1, 1, function(json) {
      return console.log('Mob: ' + mob);
    });
    /* Load the towers */
    return Game;
  })();
}).call(this);
