require 'pry'

SUITS = ['H', 'D', 'S', 'C']
CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
CARD_VALUES = {'2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'J' => 10, 'Q' => 10, 'K' => 10, 'A' =>11}
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
  prompt "#{person[:name]} has: #{person[:cards]}"
end

def show_score(person)
  prompt "#{person[:name]}'s score is: #{person[:score]}"
end

prompt "Welcome to Black Jack"

deck = initialize_deck

player_cards = []
dealer_cards = []

player = {
  cards: [],
  score: 0,
  name: 'Player',
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
prompt "Your cards are now #{player[:cards][0]} and #{player[:cards][1]}, for a total of #{player[:score]}"

loop do
  player_turn = nil
  loop do
    prompt "Would you like to (h)it or (s)tay?"
    player_turn = gets.chomp
    break if %w(h hit s stay).include?(player_turn)
    prompt "Sorry, must enter 'h' or 's'"
  end

  if %w(h hit).include?(player_turn)
    prompt "You choose to hit!"
    prompt "Dealing another card for the player"
    player[:cards] << deck.shift
    show_hand(player)
    player[:score] = total(player[:cards])
    show_score(player)
  end

  break if %w(s stay).include?(player_turn) || busted?(player[:score])
end

puts "========================="
show_hand(dealer)
show_score(dealer)


until dealer[:score] >= DEALER_MIN
  prompt "Dealing another card to the dealer"
  dealer[:cards] << deck.shift
  show_hand(dealer)
  dealer[:score] = total(dealer[:cards])
  show_score(dealer)
end

puts "========================="
puts "#{player[:name]} has: #{player[:cards]}, for a total of: #{player[:score]}"
puts "#{dealer[:name]} has: #{dealer[:cards]}, for a total of: #{dealer[:score]}"
puts "========================="


if player[:score] > BLACKJACK && dealer[:score] > BLACKJACK
  prompt "You and dealer busted! It's a tie!"
elsif (player[:score] > dealer[:score] || dealer[:score] > BLACKJACK) && player[:score] <= BLACKJACK
  prompt "You win!"
elsif (dealer[:score] > player[:score] || player[:score] > BLACKJACK) && dealer[:score] <= BLACKJACK
  prompt "Dealer wins!"
else
  prompt "It's a tie!"
end
