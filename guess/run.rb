#
# Ruby For Kids Projects 6: Guessing Game
# Programmed By: Chris Haupt
# A guessing game in which the hints might not be true
#

require_relative "game"
require_relative "player"

puts "Welcome to the Guessing Game"
puts "We will play #{Game::TOTAL_ROUNDS} rounds. Try to guess the number"
puts "I'm thinking of in the fewest guesses."
puts "You'll also estimate how many guesses it will take."
puts "If you do it in fewer guesses, you'll gain bonus points!"
puts ""

print "What is your name? "
name    = gets.chomp
player  = Player.new(name)
game    = Game.new(player)

while !game.done? do
  puts ""
  puts "------> Round ##{game.round}"
  puts ""
  if game.get_high_number
    if game.get_guess_count
      game.prepare_computer_number
      while !game.round_done? do
        puts ""
        game.get_player_guess
        game.show_results
      end
      game.next_round
    end
  end
end

puts ""
game.print_final_score
