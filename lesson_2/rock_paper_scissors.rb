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
  (first == 'scissors' && second == 'paper') ||
    (first == 'paper' && second == 'rock') ||
    (first == 'rock' && second == 'lizard') ||
    (first == 'lizard' && second == 'spock') ||
    (first == 'spock' && second == 'scissors') ||
    (first == 'scissors' && second == 'lizard') ||
    (first == 'lizard' && second == 'paper') ||
    (first == 'paper' && second == 'spock') ||
    (first == 'spock' && second == 'rock') ||
    (first == 'rock' && second == 'scissors')
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

    if VALID_CHOICES.key?(choice)
      break
    else
      prompt("That's not a valid choice")
    end
  end

  computer_choice = VALID_CHOICES.keys.sample

  prompt("You chose: #{VALID_CHOICES[choice]}")
  prompt("Computer chose: #{VALID_CHOICES[computer_choice]}")

  display_results(VALID_CHOICES[choice], VALID_CHOICES[computer_choice])

  if win?(VALID_CHOICES[choice], VALID_CHOICES[computer_choice])
    player_winnings_count += 1
  elsif win?(VALID_CHOICES[computer_choice], VALID_CHOICES[choice])
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
