$gtk.reset
=begin

case @piece_type
when @piece_type = @z
  r,g,b = 255,0,0
when @piece_type = @s
  r,g,b = 0,255,0
when @piece_type = @i
  r,g,b = 0,255,255
when @piece_type = @o
  r,g,b = 255,255,0
when @piece_type = @j
  r,g,b = 0,0,255
when @piece_type = @t
  r,g,b = 255,0,255
when @piece_type = @l
  r,g,b = 255,127,0
else

def render_hold_piece
  offset = 2
  @held_piece = @next_piece
  @args.outputs.labels << [1070, 650, "Held Piece",    4,0,255,255,255]
  if @held_piece == [ [X,X,X,X] ]
    render_piece @held_piece, 21,offset+2
  else
    render_piece @held_piece, 20,offset+3
  end
  render_grid_border 18, offset, 7,8
end

if @next_piece == [ [X,X,X,X] ]
  render_piece @next_piece, 15,offset+2
else
  render_piece @next_piece, 14,offset+3
end



=end
class TetrisGame
  def initialize args
    @lines_cleared = 0
    @level = 1
    @next_move = 30
    @args = args
    @score = 0
    @next_piece = nil
    @gameover = false
    @grid_w = 10
    @grid_h = 20
    @current_piece_y = 0
    @current_piece_x = 5
    @current_piece = [ [1,1], [1,1] ]
    @grid = []
    for x in 0..@grid_w-1 do
      @grid[x] = []
      for y in 0..@grid_h-1 do
        @grid[x][y] = 0
      end
    end
    @color_index = [
      [ 255, 255, 255], #white
      [ 255, 127, 0 ], #orange
      [ 255, 0, 0 ], #red
      [ 255, 0, 255 ], #pink
      [ 0, 255, 0 ], #green
      [ 255, 255, 0 ], #yellow
      [ 0, 255, 255 ], #cyan
      [ 0, 0, 255 ], #blue
      [ 0, 0, 0 ], #black
      [ 127, 127, 127 ] #grey
    ]
    select_next_piece
    select_next_piece
  end
  def render_score
    @args.outputs.labels << [160, 635, "Current Score",10,255,255,255,255]
    @args.outputs.labels << [260, 585, "#{@score}",10,255,255,255,255]
    @args.outputs.labels << [160, 535, "Lines Cleared",10,255,255,255,255]
    @args.outputs.labels << [260, 485, "#{@lines_cleared}",10,255,255,255,255]
    @args.outputs.labels << [160, 335, "Current Level",10,255,255,255,255]
    @args.outputs.labels << [260, 285, "#{@level}",10,255,255,255,255]

  end
  def render_cube x,y,color,border=8
    boxsize = 30
    grid_x = (1280 - (@grid_w * boxsize)) / 2
    grid_y = (720 - ((@grid_h-2) * boxsize)) / 2
    @args.outputs.solids << [ grid_x + (x * boxsize), (720 - grid_y) - (y * boxsize), boxsize, boxsize, *@color_index[color] ]
    @args.outputs.borders << [ grid_x + (x * boxsize), (720 - grid_y) - (y * boxsize), boxsize, boxsize, *@color_index[border] ]
  end
  def render_grid
    for x in 0..@grid_w-1 do
      for y in 0..@grid_h-1 do
        render_cube x,y, @grid[x][y] if @grid[x][y] != 0
      end
    end
  end
  def render_grid_border x,y,w,h
    color = 9
    border = 0
    for i in x..(x+w)-1 do
      render_cube i, y, color, border
      render_cube i, (y+h)-1, color, border
    end
    for i in y..(y+h)-1 do
      render_cube x, i, color, border
      render_cube (x+w)-1, i, color, border
    end
  end
  def render_background
    @args.outputs.solids << [ 0, 0, 1280, 720]
    render_grid_border -1, -1, @grid_w + 2, @grid_h + 2
  end
  def render_piece piece, piece_x, piece_y
    for x in 0..piece.length-1 do
      for y in 0..piece[x].length-1 do
        render_cube piece_x + x, piece_y + y, *piece[x][y] if piece[x][y] != 0
      end
    end
  end
  def render_current_piece
    render_piece @current_piece, @current_piece_x, @current_piece_y
  end
  def render_next_piece
    # !!! FIXME: dont hardcore these numbers
    render_grid_border 12, 2,7, 8
    center_x = (5 - @next_piece.length) / 2
    center_y = (8 - @next_piece[0].length) / 2
#    render_piece @next_piece, 14,offset+3
    render_piece @next_piece, 13+center_x,2+center_y
    @args.outputs.labels << [860, 665, "Next Piece",10,255,255,255,255]
  end
  def render
    render_background
    render_grid
    render_next_piece
    render_current_piece
    render_score
  end
  def current_piece_colliding
    for x in 0..@current_piece.length-1 do
      for y in 0..@current_piece[x].length-1 do
        if (@current_piece[x][y] != 0)
          if (@current_piece_y + y >= @grid_h-1)
            return true
          elsif (@grid[@current_piece_x + x][@current_piece_y + y + 1] != 0 )
            return true
          end
        end
      end
    end
    return false
  end
#  def randomize_piece
#    [@o, @s, @j, @l, @t, @i, @z].sample
#  end
  def select_next_piece
    @current_piece = @next_piece
    X = rand(7) + 1
    @next_piece = case X
    when 1 then [ [0,X], [0,X], [X,X] ] #l
    when 2 then [ [0,X], [X,X], [X,0] ] #z
    when 3 then [ [X,0], [X,X], [X,0] ] #t
    when 4 then [ [X,0], [X,X], [0,X] ] #s
    when 5 then [ [X,X],[X,X] ]         #o
    when 6 then [ [X,X,X,X] ]           #i
    when 7 then [ [X,X], [0,X], [0,X] ] #j
    end
  end

  def plant_current_piece
    #plant piece into grid
    for x in 0..@current_piece.length-1 do
      for y in 0..@current_piece[x].length-1 do
        if @current_piece[x][y] != 0
          @grid[@current_piece_x + x][@current_piece_y + y] = @current_piece[x][y]
        end
      end
    end
    @current_piece_y = 0
    @current_piece_x = 5
    select_next_piece
    for y in 0..@grid_h-1
      full = true
      for x in 0..@grid_w-1
        if @grid[x][y] == 0
          full = false
          break
        end
      end
      if full
        #adds 1 to line_clearing
        @line_clearing += 1
        @lines_cleared += 1
        for i in y.downto(1) do
          for j in 0..@grid_w-1
            @grid[j][i] = @grid[j][i-1]
          end
        end
        for i in 0..@grid_w-1
          @grid[i][0] = 0
        end
      end
    end
    case @line_clearing
    when 1 then @score += (40 * @level+1)
    when 2 then @score += (100 * @level+1)
    when 3 then @score += (300 * @level+1)
    when 4 then @score += (1200 * @level+1)
    end
    if (@lines_cleared != 0) && (@lines_cleared % 10 == 0)
      @level += 1
    end
    @line_clearing = 0
    @score += 1
#    @current_piece = randomize_piece
  end
  def rotate_current_piece
    @current_piece = @current_piece.transpose.map(&:reverse)
    if @current_piece_x + @current_piece.length >= @grid_w
      @current_piece_x = @grid_w - @current_piece.length
    end
  end
  def iterate
    kd = @args.inputs.keyboard.key_down
    kh = @args.inputs.keyboard.key_held
    if kd.left || kd.a
      if @current_piece_x > 0
        @current_piece_x -= 1
      end
    end
    if kd.right || kd.d
      if @current_piece_x + @current_piece.length < @grid_w
        @current_piece_x += 1
      end
    end
    if kh.down || kd.down || kh.s || kd.s
      @next_move -= 3
    end
    if kd.up || kd.w
      rotate_current_piece
    end
    if kd.r || kh.r
      $gtk.reset
    end
    @next_move -= (1 * @level+1)/2
    if @next_move <= 0
      if current_piece_colliding
        plant_current_piece
#        @current_piece = randomize_piece
#        @piece_type = randomize_piece
      else
        @current_piece_y += 1
      end
      @next_move = 30
    end
  end
  def tick
    iterate
    render
  end
end

def tick args
  args.state.game ||= TetrisGame.new args
  args.state.game.tick
end
