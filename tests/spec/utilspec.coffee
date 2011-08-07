### Utilities Tests ###
basedir = '../../'  # 
Grid = (require basedir + 'controllers/utils/grid.js').Grid

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
    @grid.get [1,1], (res) ->
      expect(res).toEqual(0)
  it 'Converts to JSON', ->
    self = @  # Hack for js closures
    @grid.toJSON (res) ->
      expect(res.grid).toBeDefined()
      expect(res.grid.length).toEqual(11)    # Check first dimension
      expect(res.grid[0].length).toEqual(11) # Check second dimension
      expect(res.h).toEqual(self.size)
      expect(res.w).toEqual(self.size)  
  it 'Converts to a String', ->
    self = @
    @grid.toString (res) ->
      expect(res).toBeDefined()
      expect(res).toEqual('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
  it 'Sets 1,1 to a monster', ->
    @grid.set [1,1], 'm', ->
    @grid.get [1, 1], (res) ->
      expect(res).toEqual('m')
