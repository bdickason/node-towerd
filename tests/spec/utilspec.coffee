### Utilities Tests ###
basedir = '../../'  # 
App = require basedir + 'app.js'
Grid = (require basedir + 'controllers/utils/grid').Grid
Graph = (require basedir + 'controllers/utils/graph').Graph
astar = (require basedir + 'controllers/utils/astar').astar

# Unit Tests
describe '2d Grid utils/grid.js', ->
  beforeEach ->
    # Stub data
    @size = 10
    @grid = new Grid (@size)

  it 'Creates a 10x10 grid', ->
    expect(@grid).toBeDefined()
    expect(@grid.h).toEqual(@size)
    expect(@grid.w).toEqual(@size)
  it 'Populates with 0s', ->
    @grid.get 1,1, (res) ->
      expect(res).toEqual(0)
  it 'Converts to a String', ->
    @grid.toString (res) ->
      expect(res).toBeDefined()
      expect(res).toEqual('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
  it 'Sets 1,1 to a monster', ->
    @grid.set 1, 1, 'm', ->
    @grid.get 1, 1, (res) ->
      expect(res).toEqual('m')


describe '2d Graph utils/graph.js', ->
  beforeEach ->
    # Stub data
    @size = 10
    @graph = new Graph @size

  it 'Creates a 10x10 empty grid', ->
    expect(@graph).toBeDefined()
    expect(@graph.toString().length).toEqual 211
    expect(@graph.nodes[0][0].isWall()).toBeFalsy()
    expect(@graph.nodes[9][9].isWall()).toBeFalsy()
    expect(@graph.nodes[15]).toBeUndefined()

  it 'Can add a wall to the grid at 3, 6', ->
    @graph.nodes[3][6].wall() 
    expect(@graph.nodes[3][6].isWall()).toBeTruthy()


describe 'A* Pathing utils/astar.js', ->
  beforeEach ->
    # Stub data
    @size = 10
    @graph = new Graph @size

  it 'Can path from 0,0 to 4,4', ->
    start = @graph.nodes[0][0]
    end = @graph.nodes[4][4]
    @path = astar.search @graph.nodes, start, end

    # apply the path to the graph
    for hop in @path
      @graph.nodes[hop.x][hop.y].path()

    expect(@graph.nodes[0][0].isWall()).toBeFalsy() 
    expect(@graph.nodes[4][4].isWall()).toBeFalsy()
    expect(@graph.nodes[0][0].isPath()).toBeFalsy() # Current point is not path'd
    expect(@graph.nodes[4][4].isPath()).toBeTruthy() 
    expect(@graph.nodes[8][9].isPath()).toBeFalsy()

  it 'Can path around a single wall at 2, 2', ->
    start = @graph.nodes[0][0]
    end = @graph.nodes[4][4]
    wall = @graph.nodes[3][4]
    wall.wall()
    @path = astar.search @graph.nodes, start, end

    # apply the path to the graph
    for hop in @path
      @graph.nodes[hop.x][hop.y].path()

    expect(@graph.nodes[3][4].isWall()).toBeTruthy() 
    expect(@graph.nodes[0][0].isPath()).toBeFalsy() # Current point is not path'd
    expect(@graph.nodes[4][4].isPath()).toBeTruthy() 
    expect(@graph.nodes[8][9].isPath()).toBeFalsy()