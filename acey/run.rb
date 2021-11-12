#
# Ruby For Kids Project 9: Acey Deucy
# Programmed By: Chris Haupt
# A multiplayer card game where you try to guess whether the next card will be between two other cards, placing bets on the results
#

require_relative "game"
require_relative "deck"
require_relative "card"
require_relative "player"

STARTING_NUMBER_OF_CHIPS = 10
MINIMUM_PLAYERS          = 2

puts "Welcome to Acey Deucy"
print "Enter number of players :"
player_count = gets
player_count = player_count.to_i

if player_count >= MINIMUM_PLAYERS
   # Load up some players
   players = []
  # Add code to create players here
  (0...player_count).each do |index|
    print "Enter name for player ##{index + 1}: "
    name = gets
    name = name.chomp
    players << Player.new(name, STARTING_NUMBER_OF_CHIPS)
  end
else
  puts "There should be at least #{MINIMUM_PLAYERS}"
end
