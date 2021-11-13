$gtk.reset
class TetrisGame
  BORDER_TYPE = "border"
  TILE_TYPE = "tile"
  def initialize args
    @args = args
    @score = 0
    @gameover = false
    @grid_w = 10
    @grid_h = 20
    @current_piece_x = 5
    @current_piece_y = 0
        @z_piece = [ [0,1,1], [1,1,0]]
        @s_piece = [ [1,1,0],[0,1,1] ]
        @i_piece = [ [1,1,1,1] ]
        @o_piece = [ [1,1],[1,1] ]
        @t_piece = [ [1,1,1],[0,1,0] ]
        @l_piece = [ [1,1,1],[0,0,1] ]
        @j_piece = [ [1,1,1],[1,0,0] ]
        @piece_type = "o"
    @current_piece = [ [1,1],[1,1] ]
    @grid = []
    for x in 0..@grid_w-1 do
      @grid[x] = []
      for y in 0..@grid_h-1 do
        @grid[x][y] = 0
      end
    end
  end
  def render_score
  end
  def render_cube x,y, type
    case type
    when "tile"
      case @piece_type
      when @piece_type = "j"
        r,g,b = 0,0,255
      when @piece_type = "o"
        r,g,b = 255,255,0
      else
        r,g,b = 255,0,0
      end
    when "border"
      r,g,b = 255,255,255
    end


    boxsize = 30
    grid_x = (1280 - (@grid_w * boxsize)) / 2
    grid_y = (720 - ((@grid_h-2) * boxsize)) / 2
    @args.outputs.solids << [grid_x + (x * boxsize), (720 - grid_y) - (y * boxsize), boxsize, boxsize, r, g, b, 255]
  end
  def render_grid
    for x in 0..@grid_w-1 do
      for y in 0..@grid_h-1 do
        render_cube x,y, TILE_TYPE if @grid[x][y] != 0
      end
    end
  end
  def render_grid_border
    x = -1
    y = -1
    w = @grid_w + 2
    h = @grid_h + 2
    for i in x..(x+w)-1 do
      render_cube i, y, BORDER_TYPE
      render_cube i, (y+h)-1, BORDER_TYPE
    end
    for i in y..(y+h)-1 do
      render_cube x, i, BORDER_TYPE
      render_cube (x+w)-1, i, BORDER_TYPE
    end
  end
  def render_background
    @args.outputs.solids << [ 0, 0, 1280, 720, 0, 0, 0]
    render_grid_border
  end
  def render_current_piece
    for x in 0..@current_piece.length-1 do
      for y in 0..@current_piece[x].length-1 do
        render_cube @current_piece_x + x, @current_piece_y + y, TILE_TYPE if @current_piece[x][y] != 0
      end
    end
  end
  def render
    render_background
    render_grid
    render_current_piece
    render_score
  end
  def tick
    render
  end
end

def tick args
  args.state.game ||= TetrisGame.new args
  args.state.game.tick
end
