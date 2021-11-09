class Game
  attr_reader :players, :deck, :bank, :round
  ANTE_AMOUNT = 1
  def initialize(players)
    @players = players
    @deck = Deck.new(Card.create_cards)
    @deck.shuffle
    @bank = 0
    @round = 0
  end
  def remaining_players
    player.count {|player| !player.eliminated?}
  end

  def new_round
    @round += 1
    players.each do |player|
      player.discard_hand
    end
  end
  def ante
    players.each do |player|
      if !player.eliminated?
        @bank = @bank + player.pay(ANTE_AMOUNT)
      end
    end
  end
  def deal_cards(num_of_cards)
    players.each do |player|
      next if player.eliminated?
      1.upto(num_of_cards) do
        player.take_card(deck.deal)
      end
    end
  end
  def sort_cards
    players.each do |player|
      next if player.eliminated?
      player.sort_hand_by_rank
    end
  end
  def max_bet(player)
    [player.chips, bank].min
  end
  def players_bet
    players.each do |player|
      if player.eliminated?
        puts "#{player.name} can bet between 0 and #{max_bet(player)}: "
        bet = gets.to_i
        if bet < 0 || bet > max_bet(player)
          bet = 0
        end
        puts "#{player.name} bet #{bet}"
        player.bet = bet
      end
    end
  end
  def play
    while deck.size > (players.length * 3) && remaining_players > 1 do
      new_round
      puts "-" * 40
      puts "Round ##{round}! The dealer has #{bank} chips."
      puts "-" * 40
      puts "Everyone antes"
      ante
      puts "The dealer now has #{bank} chips."
      deal_cards(2)
      sort_cards
      puts "---> Current cards:\n"
      show_cards
      puts "---> Players bet:\n"
      players_bet
      puts "\n---> Dealer deals one more card\n"
      deal_cards(1)
      show_cards
      puts "---> Determining results\n"
      determine_results
      puts "\n---> New standings\n"
      show_player_chips
      puts ""
    end
    game_over
  end
end
