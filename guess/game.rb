class Game
  # Game class code goes here
  TOTAL_ROUNDS = 3
  def initialize(player)
    @player = player
    @round  = 0
    next_round
  end
  def next_round
    @computers_number = 0
    @round_done = false
    @round += 1
    @player.prepare_for_new_round
  end
  def round
    @round
  end
  def done?
    @round > TOTAL_ROUNDS
  end
  def round_done?
    @round_done
  end
  def get_high_number
    print "I'll pick a number between 1 and what number? "
    high_number = @player.get_high_number
    if high_number <= 1
      puts "Oops! The number must be larger than 1. Try again."
      return false
    else
      return true
    end
  end
  def get_guess_count
    average = calculate_typical_number_of_guesses
    puts "How many guess do you think it will take?"
    print "(average would be #{average}):"
    total_guess_count = @player.get_total_guess_count
    if total_guess_count < 1
      puts "seriously #{@player.name}?! You need to at least try!"
      return false
    else
      return true
    end
  end
  def calculate_typical_number_of_guesses
    typical_count = Math.sqrt(@player.high_number)
    typical_count.round
  end
  def prepare_computer_number
    @computers_number = rand(@player.high_number) + 1
  end
  ###########################################
  # Everything above is setting up the game #
  #      Everything below runs the game     #
  ###########################################
  def compare_player_guess_to_computer_number
    if @player.current_guess == @computers_number
      @round_done = true
      puts "YEAH!!!!! You guessed it!"
      calculate_score
    else
      show_hint
    end
  end
  def get_player_guess
    print "#{@player.name}, what is your guess? "
    @player.get_guess
    compare_player_guess_to_computer_number
  end
  def show_hint
    hints = ["low", "high"]
    if @player.current_guess < @computers_number
      hint_index = 0
    else
      hint_index = 1
    end
    if !tell_truth?
      hint_index = hint_index - 1
      hint_index = hint_index.abs
    end
    puts "HINT: You are too #{hints[hint_index]}"
  end
  def tell_truth?
    rand(100) >= 4
  end
  def calculate_score
    score = 0
    if @player.guess_count > @player.total_guess_count
      score = 1
    elsif @player.total_guess_count < calculate_typical_number_of_guesses
      score = 3
    else
      score = 5
    end
    @player.add_score
  end
  def show_results
    puts "guess count: #{@player.guess_count} target: #{@player.total_guess_count}"
  end
  def print_final_score
    puts "Final score for #{@player.name} is #{@player.score}"
  end
end
