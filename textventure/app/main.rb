=begin
===========CODE CLIPBOARD=============

=end


$gtk.reset
class TextGame
  def initialize args
    @args = args
    @gameover = false
    @game_started = false
    @stage = "start"
    @inventory = [ "-", "-", "-", "-", "-"]
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
  def label_title text
    label_white text, 640, 500, 30, 1
  end
  def label_sub text
    label_white text, 640, 400, 10, 1
  end
  def label_1 text
    label_white text, 640, 300, 10, 1
  end
  def label_2 text
    label_white text, 640, 250, 10, 1
  end
  def label_3 text
    label_white text, 640, 200, 10, 1
  end
  def label_4 text
    label_white text, 640, 150, 10, 1
  end
  def quad x=0, y=0, w=1280, h=720, r=0, g=0, b=0, a=255
    @args.outputs.solids << [x,y,w,h,r,g,b,a]
  end
  def render_inventory x, y
    label_white "Inventory", x, y, 3
    label_white "S: #{@inventory[0]}", x, y-30, 1
    label_white "A: #{@inventory[1]}", x, y-60, 1
    label_white "3: #{@inventory[2]}", x, y-90, 1
    label_white "4: #{@inventory[3]}", x, y-120, 1
    label_white "5: #{@inventory[4]}", x, y-150, 1
  end
  def render
    quad   0,  0, 1280, 720
    render_inventory 80, 290 unless (@stage == "start" || @draw_inventory == false)
    case @stage
    when "start"
      quad 150,300, 1090, 220, 0, 128
      quad 450,230,  500,  90, 0, 180
      label_white "RUBY'S VENTURE", 640, 500, 50, 1
      label_white "Press 'Space' to start", 500, 295, 10
      label_white "A text based choice game by Raven Love", 625, 390, 5
    when "room"
      label_title "ROOM"
      label_2 "- (E)XIT"
      label_1 "- (S)EARCH" if !@sword_found
      label_1 "GEAR!" if @sword_found
    when "room2"
      label_title "DRAGON"
      label_1 "- (A)TTACK"
      label_2 "- (F)LEE"
    when "success"
      label_title "WON!"
      label_1 "Press 'Space' to restart"
    when "fail"
      label_title "TAIL!"
      label_1 "Press 'Space' to restart"
    when "fail 2"
      label_title "FIRE!"
      label_1 "Press 'Space' to restart"
    end
  end

  def iterate
    kd = @args.inputs.keyboard.key_down
    kh = @args.inputs.keyboard.key_held
    case @stage
    when "start"
      @stage = "room" if kd.space
    when "room"
      @stage = "room2" if kd.e
      @sword_found = true unless @sword_found if kd.s
      @inventory[0] = "Sword" if kd.s
    when "room2"
      if kd.a
        @stage = "success" if @sword_found
        @stage = "fail" if !@sword_found
      end
        @stage = "fail 2" if kd.f
    when "success"
      @draw_inventory = false
      $gtk.reset if kd.space || kh.space
    when "fail"
      @draw_inventory = false
      $gtk.reset if kd.space || kh.space
    when "fail 2"
      @draw_inventory = false
      $gtk.reset if kd.space || kh.space
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
