### 	astar.js http://github.com/bgrins/javascript-astar
	MIT License
	
	Implements the astar search algorithm in javascript using a binary heap

  Example usage:
    start = graph.nodes[0][0]
    end = graph.nodes[1][2]
    astar.search graph.nodes, start, end

###
	
exports.astar = astar = {
  init: (grid) ->
    for x in [0...grid.length]
      for y in [0...grid.length]
        node = grid[x][y]
        node.f = 0
        node.g = 0
        node.h = 0
        node.visited = false
        node.closed = false
        node.debug = ''
        node.parent = null
  
  search: (grid, start, end, heuristic) ->
    astar.init grid
    heuristic = heuristic || astar.manhattan
      
    openHeap = new BinaryHeap (node) =>
      return node.f
    
    openHeap.push start
    
    while openHeap.size() > 0
      # Grab the lowest f(x) to process next. Heap keeps this sorted.
      currentNode = openHeap.pop()
            
      # End case: Result has been found, return the traced path
      if currentNode == end
        curr = currentNode
        ret = []
        while curr.parent
          ret.push curr
          curr = curr.parent
        return ret.reverse()
      
      # Normal case: move current node from open to closed
      #              process each of its neighbors
      currentNode.closed = true
      
      neighbors = astar.neighbors grid, currentNode
      
      for i in [0...neighbors.length]
        neighbor = neighbors[i]
        
        if neighbor.closed || neighbor.isWall()
          # Not a valid node to process, skip to next neighbor
          continue

        # g score is shortest distance from start to current
        #   We need to check if the path we arrivd at is the shortest yet
        #   Currently we use '1' as the distance from node to neighbor but this could change for weighted paths
        
        gScore = currentNode.g + 1
        beenVisited = neighbor.visited
        
        if !beenVisited || gScore < neighbor.g
          
          # Found an optimal path (so far) to this node. Take score for node to see how good it is
          neighbor.visited = true
          neighbor.parent = currentNode
          neighbor.h = neighbor.h || heuristic neighbor.pos, end.pos
          neighbor.g = gScore
          neighbor.f = neighbor.g + neighbor.h
          neighbor.debug = "F: #{neighbor.f} G: #{neighbor.g} H: #{neighbor.h}"
          
          if !beenVisited
            # Pushing to heap will put it in its proper place based on the 'f' value
            openHeap.push neighbor
          else
            # Already seen the node, but since it has been rescored we need to reorder it in the heap
            openHeap.rescoreElement neighbor

    # No result was found -- empty array signifies failure to find path
    return []        
  
  manhattan: (pos0, pos1) ->
    # See list of heuristics: http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html
    d1 = Math.abs (pos1.x - pos0.x)
    d2 = Math.abs (pos1.y - pos0.y)
    return d1 + d2
  
  neighbors: (grid, node) ->
    ret = []
    x = node.x
    y = node.y
    
    if grid[x-1] and grid[x-1][y]
      ret.push grid[x-1][y]
    if grid[x+1] and grid[x+1][y]
      ret.push grid[x+1][y]
    if grid[x] and grid[x][y-1]
      ret.push grid[x][y-1]
    if grid[x] and grid[x][y+1]
      ret.push grid[x][y+1]
    
    return ret
}

exports.BinaryHeap = class BinaryHeap
  constructor: (scoreFunction) ->
    @content = []
    @scoreFunction = scoreFunction

  push: (element) ->
    # Add the new element to the end of the array
    @content.push element

    # Allow it to sink down
    @sinkDown @content.length-1
  
  pop: ->
    # Store the first element so we can return it later
    result = @content[0]

    # Get the element at the end of the array
    end = @content.pop()
    
    # If there are any elements left, put the end element at the start and bubble it up
    if @content.length > 0
      @content[0] = end
      @bubbleUp 0
    
    return result
  
  remove: (node) ->
    i = @content.indexOf node
    
    # When it's found, the process seen in 'pop' is repeated to fill the hole
    end = @content.pop()
    if i != (@content.length - 1)
      @content[i] = end
      if (@scoreFunction end) < (@scoreFunction node)
        @sinkDown i
      else
        @bubbleUp i
  
  size: ->
    @content.length
  
  rescoreElement: (node) ->
    @sinkDown @content.indexOf node
  
  sinkDown: (n) ->
    # Fetch the element that has to be sunk
    element = @content[n]
    while n > 0
      parentN = ((n + 1) >> 1) - 1
      parent = @content[parentN]
      if (@scoreFunction element) < (@scoreFunction parent)
        @content[parentN] = element
        @content[n] = parent
        # Update 'n' to continue at the new position
        n = parentN
      else
        break
  
  bubbleUp: (n) ->
    # Look up the target element and its score
    length = @content.length
    element = @content[n]
    elemScore = @scoreFunction element
    
    while true
      child2N = (n + 1) << 1
      child1N = child2N - 1
      
      swap = null # Used to store the new position
      
      if child1N < length
        # Look it up and compute its score
        child1 = @content[child1N]
        child1Score = @scoreFunction child1
      
        # If the score is less than our element's, we need to swap
        if child1Score < elemScore
          swap = child1N
      
      # Do the same checks for the other child
      if child2N < length
        child2 = @content[child2N]
        child2Score = @scoreFunction(child2)
        tmpscore
        if swap == null
          tmpscore = elemScore
        else
          tmpscore = child1Score
        if child2Score < tmpscore
          swap = child2N
      
      # If the element needs to be moved, swap it, and continue
      if swap != null
        @content[n] = @content[swap]
        @content[swap] = element
        n = swap
      # Otherwise we're done
      else
        break
