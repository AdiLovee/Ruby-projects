class Player
  # Player class code goes here
  def initialize(name)
    def prepare_for_new_round
      @total_guess_count          = 0
      @high_number                = 0
      @current_guess              = 0
      @current_number_of_guesses  = 0
    end
    # instance variables, used only within the defined object
    @name     = name
    @score    = 0
    prepare_for_new_round
    def name
      @name
    end
    def score
      @score
    end
    def total_guess_count
      @total_guess_count
    end
    def high_number
      @high_number
    end
    def current_guess
      @current_guess
    end
    def guess_count
      @guess_count
    end
    def add_score(points)
      @score += points
    end
    def get_high_number
      @high_number = gets.to_i
    end
    def get_total_guess_count
      @total_guess_count = gets.to_i
    end
    def get_guess
      @current_number_of_guesses += 1
      @current_guess = gets.to_i
    end
  end
end
