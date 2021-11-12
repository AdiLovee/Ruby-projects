#
# Ruby For Kids Projects 11: Tower of Hanoi
# Programmed By: Chris Haupt
# Towers of Hanoi puzzle
#
# to run the program use:
# run.bat
#

require 'gosu'
require_relative 'game'

class Tower < Gosu::Window
  def initialize
    super(800, 600, false)
    self.caption = "Tower of Hanoi"
    @game = Game.new(self)
  end
  def needs_cursor?
    true
  end
  def button_down(id)
    @game.button_down(id)
  end
  def draw
    @game.draw
  end
  def update
    @game.update
  end 
end

window = Tower.new
window.show
