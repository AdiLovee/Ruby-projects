$gtk.reset
class TextGame
  def initialize args
    @args = args
    @gameover = false
    @game_started = false
    @stage = "start"
    @sword_found
  end

  def label_black text="New_Label", x=640, y=360, size=0, align=0
    @args.outputs.labels << [x, y, text, size, align, 0,0,0,255]
  end
  def label_white text="New_Label", x=640, y=360, size=0, align=0
    @args.outputs.labels << [x, y, text, size, align, 255,255,255,255]
  end
  def label text="New_Label", x=640, y=360, size=0, align=0, r=0, g=0, b=0, a=2555
    @args.outputs.labels << [x, y, text, size, align, r,g,b,a]
  end
  def quad x=0, y=0, w=1280, h=720, r=0, g=0, b=0, a=255
    @args.outputs.solids << [x,y,w,h,r,g,b,a]
  end

  def render_start_credits
    quad   0,  0, 1280, 720
    quad 150,300, 1090, 220, 0, 128
    quad 450,230,  500,  90, 0, 180
    label_white "RUBY'S VENTURE", 640, 500, 50, 1
    label_white "Press 'Space' to start", 500, 295, 10
    label_white "A text based choice game by Raven Love", 625, 390, 5
  end
  def render_game
    quad   0,  0, 1280, 720
    case @stage
    when "start"
      label_white "ROOM", 640, 500, 50, 1
      label_white "- (E)XIT", 640, 250, 10, 1
      if !@sword_found
        label_white "- (S)EARCH", 640, 350, 10, 1
      elsif @sword_found
        label_white "SWORD!", 640, 350, 10, 1
      end
    when "room2"
      label_white "DRAGON", 640, 500, 50, 1
      label_white "- (A)TTACK", 640, 250, 10, 1
      label_white "- (F)LEE", 640, 350, 10, 1
    when "success"
      quad   0,  0, 1280, 720
      label_white "WON!", 640, 500, 50, 1
      label_white "Press 'Space' to restart", 640, 250, 10, 1
    when "fail"
      quad   0,  0, 1280, 720
      label_white "TAIL!", 640, 500, 50, 1
      label_white "Press 'Space' to restart", 640, 250, 10, 1
    when "fail 2"
      quad   0,  0, 1280, 720
      label_white "FIRE!", 640, 500, 50, 1
      label_white "Press 'Space' to restart", 640, 250, 10, 1
    end
  end

  def render
    if !@game_started
      render_start_credits
    else
      render_game
    end
  end

  def iterate
    kd = @args.inputs.keyboard.key_down
    kh = @args.inputs.keyboard.key_held
    if !@game_started
      if kd.space
        @game_started = true
      end
    end
    case @stage
    when "start"
      if kd.e
        @stage = "room2"
      end
      if kd.s
        unless @sword_found
          @sword_found = true
        end
      end
    when "room2"
      if kd.a
        if @sword_found
          @stage = "success"
        else
          @stage = "fail"
        end
      end
      if kd.f
        @stage = "fail 2"
      end
    when "success"
      if kd.space || kh.space
        $gtk.reset
      end
    when "fail"
      if kd.space || kh.space
        $gtk.reset
      end
    when "fail 2"
      if kd.space || kh.space
        $gtk.reset
      end
    end
  end

  def tick
    iterate
    render
  end
end

def tick args
  return unless $console.hidden?
  args.state.game ||= TextGame.new args
  args.state.game.tick
end
