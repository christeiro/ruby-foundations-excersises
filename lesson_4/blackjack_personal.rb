require 'pry'

SUITS = ['H', 'D', 'S', 'C'].freeze
CARDS = ['2', '3', '4', '5', '6', '7', '8',
         '9', '10', 'J', 'Q', 'K', 'A'].freeze
CARD_VALUES = { '2' => 2, '3' => 3, '4' => 4, '5' => 5,
                '6' => 6, '7' => 7, '8' => 8, '9' => 9,
                '10' => 10, 'J' => 10, 'Q' => 10, 'K' => 10, 'A' => 11 }.freeze
BLACKJACK = 21
DEALER_MIN = 17

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  prepare_cards = []
  SUITS.each do |suit|
    CARDS.each do |card|
      prepare_cards << [suit, card]
    end
  end
  prepare_cards.shuffle!
end

def total(cards)
  values = cards.map { |card| card[1] }
  sum = 0

  values.each do |value|
    sum += CARD_VALUES[value]
  end

  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

def busted?(score)
  score > BLACKJACK
end

def show_hand(person)
  prompt "#{person[:name]} has: #{person[:cards]}. SCORE: #{person[:score]}"
end

def play_again?
  prompt "Play again? (Y)es/(N)o"
  play_again = gets.chomp
  %w(y yes).include?(play_again)
end

def detect_result(player, dealer)
  if player[:score] > BLACKJACK
    :player_busted
  elsif dealer[:score] > BLACKJACK
    :dealer_busted
  elsif player[:score] > dealer[:score]
    :player
  elsif dealer[:score] > player[:score]
    :dealer
  else
    :tie
  end
end

def display_result(player, dealer)
  result = detect_result(player, dealer)
  case result
  when :player_busted
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player
    prompt "You win!"
  when :dealer
    prompt "Dealer wins"
  when :tie
    prompt "It's a tie"
  end
end

def display_overall_score(player, dealer)
  prompt "Overall score! You have: #{player} wins || Dealer has: #{dealer} wins"
end

player_wins_count = 0
dealer_wins_count = 0

prompt "Welcome to Twnety-One!"
puts "========================="

new_game = true

loop do

  new_game = false
  puts "========================="
  puts "========================="

  deck = initialize_deck

  player = {
    cards: [],
    score: 0,
    name: 'Player'
  }

  dealer = {
    cards: [],
    score: 0,
    name: 'Dealer'
  }

  2.times do
    player[:cards] << deck.shift
    dealer[:cards] << deck.shift
  end

  player[:score] = total(player[:cards])
  dealer[:score] = total(dealer[:cards])

  prompt "Dealer has: #{dealer[:cards][1]} and ?"
  show_hand(player)

  loop do
    player_turn = nil
    loop do
      prompt "Would you like to (h)it or (s)tay?"
      player_turn = gets.chomp
      break if %w(h hit s stay).include?(player_turn.downcase)
      prompt "Sorry, must enter 'h' or 's'"
    end

    if %w(h hit).include?(player_turn)
      prompt "You choose to hit!"
      prompt "Dealing another card for the player"
      player[:cards] << deck.shift
      player[:score] = total(player[:cards])
      show_hand(player)
    end

    break if %w(s stay).include?(player_turn) || busted?(player[:score])
  end

  puts "========================="
  show_hand(dealer)

  if busted?(player[:score])
    prompt "Dealer stays!"
  else
    until dealer[:score] >= DEALER_MIN
      prompt "Dealing another card to the dealer"
      dealer[:cards] << deck.shift
      dealer[:score] = total(dealer[:cards])
      show_hand(dealer)
    end
  end

  puts "========================="
  puts "Comparing hands:"
  show_hand(player)
  show_hand(dealer)
  puts "========================="
  puts "========================="

  display_result(player, dealer)

  overall_score = detect_result(player, dealer)
  if %i(player dealer_busted).include?(overall_score)
    player_wins_count += 1
  elsif %i(dealer player_busted).include?(overall_score)
    dealer_wins_count += 1
  end

  display_overall_score(player_wins_count, dealer_wins_count)
  if player_wins_count >= 5 || dealer_wins_count >= 5
    if play_again?
      player_wins_count = 0
      dealer_wins_count = 0
    else
      prompt "Thanks for playing. Bye!"
      break
    end
  end
end
