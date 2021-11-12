#
# Ruby For Kids Projects 10: A-maze-ing
# Programmed By: Chris Haupt
# A mazelike treaure search game
#
# To run the program, use:
#   run.bat
#

require 'gosu'
require_relative 'game'

class Amazing < Gosu::Window
  def initialize
    super(640,640)
    self.caption = "Amazing"
    @game = Game.new(self)
    def update
      @game.update
    end
    def draw
      @game.draw
    end
    def button_down(id)
      @game.button_down(id)
    end
    # More code goes here
  end
  # Even more code
end

window = Amazing.new
window.show
