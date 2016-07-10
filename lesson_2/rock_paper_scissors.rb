# VALID_CHOICES = %w(rock paper scissors spock lizard)

VALID_CHOICES = {
  "r" => "rock",
  "p" => "paper",
  "s" => "scissors",
  "sp" => "spock",
  "l" => "lizard"
}

player_winnings_count = 0
computer_winnings_count = 0

def prompt(msg)
  Kernel.puts("=> #{msg}")
end

def win?(first, second)
  first == 'rock' && %w(lizard scissors).include?(second)    ||
    first == 'scissors' && %w(lizard paper).include?(second) ||
    first == 'paper' && %w(spock rock).include?(second)      ||
    first == 'spock' && %w(rock scissors).include?(second)   ||
    first == 'lizard' && %w(spock paper).include?(second)
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("You won this round!")
  elsif win?(computer, player)
    prompt("Computer won this round!")
  else
    prompt("It's a tie!")
  end
end

def display_overall_score(player_score, computer_score)
  prompt("Overall score:: You: #{player_score} | Computer: #{computer_score}")
end

loop do
  choice = ''
  loop do
    prompt("Choose one from the following:")
    VALID_CHOICES.each do |key, value|
      prompt("#{key}) #{value}")
    end

    choice = Kernel.gets().chomp()

    break if VALID_CHOICES.key?(choice)
    prompt("That's not a valid choice")
  end

  player_choice = VALID_CHOICES[choice]
  computer_choice = VALID_CHOICES.values.sample

  prompt("You chose: #{player_choice}")
  prompt("Computer chose: #{computer_choice}")

  display_results(player_choice, computer_choice)

  if win?(player_choice, computer_choice)
    player_winnings_count += 1
  elsif win?(computer_choice, player_choice)
    computer_winnings_count += 1
  end

  display_overall_score(player_winnings_count, computer_winnings_count)

  if player_winnings_count == 5 || computer_winnings_count == 5
    if player_winnings_count == 5
      prompt("You won the game!")
    else
      prompt("Computer won the game")
    end
    prompt("Do you want to play again?")
    answer = Kernel.gets().chomp()
    break unless answer.downcase().start_with?('y')
  end
end

prompt("Thank you for playing. Good bye!")
