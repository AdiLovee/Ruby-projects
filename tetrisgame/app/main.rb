=begin
===========CODE CLIPBOARD=============



=end


$gtk.reset
class TetrisGame
  def initialize args
    @game_started = false
    @lines_cleared = 0
    @level = 1
    @save_file = "mygame/app/scores.txt"
    @next_move = 30
    @args = args
    @score = 0
    @next_piece = nil
    @gameover = false
    @debug = false
    @piece_swapped = false
    @grid_w = 10
    @grid_h = 20
    @current_piece_y = 0
    @current_piece_x = 4
    @current_piece = [ [1,1], [1,1] ]
    @held_piece_full = false
    @held_piece = []
    @grid = []
    for x in 0..@grid_w-1 do
      @grid[x] = []
      for y in 0..@grid_h-1 do
        @grid[x][y] = 0
      end
    end
    @color_index = [
      [ 255, 255, 255], #white
      [ 255, 127, 0 ],  #orange
      [ 255, 0, 0 ],    #red
      [ 255, 0, 255 ],  #pink
      [ 0, 255, 0 ],    #green
      [ 255, 255, 0 ],  #yellow
      [ 0, 255, 255 ],  #cyan
      [ 0, 0, 255 ],    #blue
      [ 0, 0, 0 ],      #black
      [ 127, 127, 127 ] #grey
    ]
    load_score @save_file
    select_next_piece
    select_next_piece
  end
  def render_start_credits
    kd = @args.inputs.keyboard.key_down
    kh = @args.inputs.keyboard.key_held
    @args.outputs.solids << [  0,   0, 1280, 720, 0, 0, 0, 255]
    @args.outputs.solids << [150, 240, 1090, 220, 128, 0, 0, 255]
    @args.outputs.solids << [450, 180, 500, 90, 180, 0, 0, 255]
    @args.outputs.labels << [200, 450, "WELCOME TO RUBYTRIS", 50, 255,255,255,255]
    @args.outputs.labels << [500, 250, "Press 'Space' to start", 10, 255,255,255,255]
    @args.outputs.labels << [625, 340, "A tetris clone written in Ruby by Raven Love", 5, 255,255,255,255]
  end
  def render_debug
    @args.outputs.labels << [1080, 680, "Debug Stats",2,255,255,255,255]
    @args.outputs.labels << [1080, 660, "gameover:",1,255,255,255,255]
    @args.outputs.labels << [1080, 640, " #{@gameover}",1,255,255,255,255]
    @args.outputs.labels << [1080, 620, "next_move:",1,255,255,255,255]
    @args.outputs.labels << [1080, 600, " #{@next_move}",1,255,255,255,255]
    @args.outputs.labels << [1080, 580, "held_piece_full:",1,255,255,255,255]
    @args.outputs.labels << [1080, 560, " #{@held_piece_full}",1,255,255,255,255]
    @args.outputs.labels << [1080, 540, "current_piece_x:",1,255,255,255,255]
    @args.outputs.labels << [1080, 520, " #{@current_piece_x}",1,255,255,255,255]
    @args.outputs.labels << [1080, 500, "current_piece_y:",1,255,255,255,255]
    @args.outputs.labels << [1080, 480, " #{@current_piece_y}",1,255,255,255,255]
    @args.outputs.labels << [1080, 460, "lineclearing",1,255,255,255,255]
    @args.outputs.labels << [1080, 440, " #{@line_clearing}",1,255,255,255,255]
    @args.outputs.labels << [1080, 420, "iterate modulo",1,255,255,255,255]
    @args.outputs.labels << [1080, 400, " #{@lines_cleared % 10}",1,255,255,255,255]
  end
  def render_controls
    @args.outputs.labels << [1080, 365, "Controls",3,255,255,255,255]
    @args.outputs.labels << [1080, 340, " Move Piece",1,255,255,255,255]
    @args.outputs.labels << [1080, 320, "  a/d or left/right",1,255,255,255,255]
    @args.outputs.labels << [1080, 300, " Rotate Piece",1,255,255,255,255]
    @args.outputs.labels << [1080, 280, "  w or up",1,255,255,255,255]
    @args.outputs.labels << [1080, 260, " Rush Piece",1,255,255,255,255]
    @args.outputs.labels << [1080, 240, "  s or down",1,255,255,255,255]
    @args.outputs.labels << [1080, 220, " Reset Game",1,255,255,255,255]
    @args.outputs.labels << [1080, 200, "  r",1,255,255,255,255]
    @args.outputs.labels << [1080, 160, " Toggle Debug",1,255,255,255,255]
    @args.outputs.labels << [1080, 140, "  c",1,255,255,255,255]
  end
  def render_score
    @args.outputs.labels << [165, 625, "Current Score",6,255,0,0,0]
    @args.outputs.labels << [260, 585, "#{@score}",6,255,0,0,0]
    @args.outputs.labels << [165, 545, "Lines Cleared",6,255,0,0,0]
    @args.outputs.labels << [260, 505, "#{@lines_cleared}",6,255,0,0,0]
    @args.outputs.labels << [165, 465, "Current Level",6,255,0,0,0]
    @args.outputs.labels << [260, 425, "#{@level}",6,255,0,0,0]
    @args.outputs.labels << [165, 385, "Hi-Scores",6,255,0,0,0]
    @args.outputs.labels << [260, 355, "#{@hiscore1}",6,255,0,0,0]
    @args.outputs.labels << [260, 325, "#{@hiscore2}",6,255,0,0,0]
    @args.outputs.labels << [260, 295, "#{@hiscore3}",6,255,0,0,0]
    @args.outputs.labels << [260, 265, "#{@hiscore4}",6,255,0,0,0]
    @args.outputs.labels << [260, 235, "#{@hiscore5}",6,255,0,0,0]
    render_grid_border -13,0, 11,20
  end
  def render_gameover
    @args.outputs.solids << [  0,   0, 1280, 720, 0, 0, 0, 255]
    @args.outputs.labels << [200, 450, "GAME OVER", 100, 255,255,255,255]
    @args.outputs.labels << [500, 250, "Press 'Space' to restart", 10, 255,255,255,255]
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
    @args.outputs.sprites << [ 130, 90, 270, 540, 'background.png' ] unless @gameover
    @args.outputs.solids << [ 0, 0, 1280, 720]
  end
  def render_border
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
    render_piece @next_piece, 13+center_x,2+center_y
    @args.outputs.labels << [860, 665, "Next Piece",10,255,255,255,255]
  end
  def render_held_piece
    # !!! FIXME: dont hardcore these numbers
    @args.outputs.labels << [860, 350, "Held Piece",10,255,255,255,255]
    render_grid_border 12, 12,7, 8
    if @held_piece_full == true
      center_x = (5 - @held_piece.length) / 2
      center_y = (8 - @held_piece[0].length) / 2
      render_piece @held_piece, 13+center_x,12+center_y
    end
  end

  def get_score file
    #runs while ??????
    #read score.txt and calculate ordering of high scores
  end
  def save_score file
    #runs on game over
    #add score to score.txt
  end
  def load_score file
    #runs on game launch
    #read score.txt and modify high score variables
    if File.exists?(file)
      @hiscore1 = 0
      @hiscore2 = 0
      @hiscore3 = 0
      @hiscore4 = 0
      @hiscore5 = 0
    else
      @hiscore1 = 5000
      @hiscore2 = 2500
      @hiscore3 = 1000
      @hiscore4 = 500
      @hiscore5 = 100
    end
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
  def clear_line y
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
  def test_line_clear
    for y in 0..@grid_h-1
      full = true
      for x in 0..@grid_w-1
        if @grid[x][y] == 0
          full = false
          break
        end
      end
      if full
        clear_line y
      end
    end
  end
  def plant_current_piece
    for x in 0..@current_piece.length-1 do
      for y in 0..@current_piece[x].length-1 do
        if @current_piece[x][y] != 0
          @grid[@current_piece_x + x][@current_piece_y + y] = @current_piece[x][y]
        end
      end
    end
    @current_piece_y = 0
    @current_piece_x = 4
    select_next_piece
    test_line_clear
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
    if current_piece_colliding
      @gameover = true
    end
  end
  def rotate_current_piece
    @current_piece = @current_piece.transpose.map(&:reverse)
    if @current_piece_x + @current_piece.length >= @grid_w
      @current_piece_x = @grid_w - @current_piece.length
    end
  end

  def render
    if !@game_started
      render_start_credits
    elsif !@gameover
      render_background
      render_grid
      render_border
      render_next_piece
      render_current_piece
      render_held_piece
      render_score
      render_controls
      if @debug == true
        render_debug
      end
    else
      render_gameover
    end
  end
  def iterate
    kd = @args.inputs.keyboard.key_down
    kh = @args.inputs.keyboard.key_held
    if @gameover
      save_score @save_file
      if kd.space || kh.space
        $gtk.reset seed: Time.new.to_i
      end
      return
    end
    if !@game_started
      if kd.space
        @game_started = true
      end
    end
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
    if kd.c
      @debug = !@debug
    end
    if kd.q
      unless @held_piece_full
        @held_piece = @current_piece
        select_next_piece
        @held_piece_full = true
      else
        @current_piece, @held_piece = @held_piece, @current_piece
      end
      @current_piece_y = 0
    end
    if kd.r || kh.r
      $gtk.reset seed: Time.new.to_i
    end
    @next_move -= (1 * @level+1)/2
    if @next_move <= 0
      if current_piece_colliding
        plant_current_piece
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
  return unless $console.hidden?
  args.state.game ||= TetrisGame.new args
  args.state.game.tick
end
