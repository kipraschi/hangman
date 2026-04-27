require_relative 'host'
require_relative 'player'
require 'json'

class Game
  def initialize(max_incorrect_guesses = 6)
    @host = Host.new
    @player = Player.new
    @max_incorrect_guesses = max_incorrect_guesses
    @incorrect_guesses = []
  end

  def play
    print_greeting
    until game_won || game_lost
      input = @player.take_guess
      if player_saved(input)
        save
        next
      end
      evaluation = @host.evaluate_guess(input)
      apply_result(evaluation, input)
      print_result(evaluation)
    end
    print_outcome
  end
  
  private
  
  def player_saved(input)
    input == "_s"
  end

  def apply_result(evaluation, guess)
    case evaluation
    when :correct_letter,:correct_word
      @host.update_placeholder(guess)
    when :wrong_letter, :wrong_word
      unless @incorrect_guesses.include?(guess)
        @incorrect_guesses.push(guess) 
      end
    end
  end

  def game_won
    @host.secret_revealed?
  end
  
  def game_lost
    incorrect_guesses_remaining == 0
  end

  def print_greeting
    puts "Welcome to the game of hangman!"
    puts " - You can save your progress anytime by typing '_s'."
    puts " - You can load your past saves by typing '_l'."
    puts "Guess the word: #{@host.placeholder}"
  end

  def print_result(evaluation)
    case evaluation
    when :correct_letter
      puts "It's there: #{@host.placeholder}"
    when :wrong_letter, :wrong_word
      print "Nope, that's not it! "
      puts "You've already tried: #{@incorrect_guesses}"
      puts "Incorrect guesses remaining: #{incorrect_guesses_remaining}"
    when :correct_word
      puts "That's right!"
    when :invalid_input
      puts "That's neither a word nor a letter, try again."
    end
  end

  def print_outcome
    if game_won
      puts "\nCongratulations, you won! It was \"#{@host.placeholder}\""
    elsif game_lost 
      puts "\nYou're out of wrong guesses... Game over."
    end
  end

  def incorrect_guesses_remaining
    @max_incorrect_guesses - @incorrect_guesses.count
  end

  def save
    File.write("game_save.json", JSON.generate(game_state))
    puts "Game Saved!"
  end

  def game_state
    {
      max_incorrect_guesses: @max_incorrect_guesses,
      incorrect_guesses: @incorrect_guesses,
      placeholder: @host.placeholder,
      secret: @host.secret.join
    }
  end

end