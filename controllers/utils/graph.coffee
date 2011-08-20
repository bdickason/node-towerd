### graph.js from http://github.com/bgrins/javascript-astar
# 	  MIT License
#	
#	    Creates a Graph class used in the astar search algorithm.
#   	Includes Binary Heap (with modifications) from Marijn Haverbeke
###
    
GraphNodeType = { OPEN: 0, WALL: 1, PATH: 8 }

exports.Graph = class Graph
  constructor: (size) ->
    @nodes = []
  
    for x in [0...size]
      @nodes[x] = []
      for y in [0...size]
        @nodes[x].push new GraphNode x, y, GraphNodeType.OPEN
    
    @nodes
    
  toString: ->      
    graphString = '\n'
    nodes = @nodes
    for x in [0...nodes.length]
      rowDebug = ''
      row = nodes[x]
      for y in [0...row.length]
        rowDebug += row[y].type + ' '
      graphString = graphString + rowDebug + '\n'
    return graphString
  
exports.GraphNode = class GraphNode
  constructor: (x, y, type) ->
    @data = { }
    @x = x
    @y = y
    @pos = { x:x, y:y }
    @type = type
  
  toString: ->
    return '[' + @x + ' ' + @y + ']'
    
  wall: ->
    @type = GraphNodeType.WALL
  
  path: ->
    @type = GraphNodeType.PATH
    
  isWall: ->
    return @type == GraphNodeType.WALL

  isPath: ->
    return @type == GraphNodeType.PATH
