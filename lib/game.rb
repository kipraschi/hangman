require_relative 'host'
require_relative 'player'

class Game
  def initialize
    @host = Host.new
    @player = Player.new
    @incorrect_guesses_remaining = 6
  end

  def play
    print_greeting
    until game_won || game_lost
      guess = @player.take_guess
      evaluation = @host.evaluate_guess(guess)
      apply_result(evaluation, guess)
      print_result(evaluation)
    end
    print_outcome
  end

  private

  def apply_result(evaluation, guess)
    case evaluation
    when :correct_letter,:correct_word
      @host.update_placeholder(guess)
    when :wrong_letter, :wrong_word
      @incorrect_guesses_remaining -= 1
    end
  end

  def game_won
    @host.secret_revealed?
  end
  
  def game_lost
    @incorrect_guesses_remaining == 0
  end

  def print_greeting
    puts "Welcome to the game of hangman!"
    puts "Guess the word: #{@host.placeholder}"
  end

  def print_result(evaluation)
    case evaluation
    when :correct_letter
      puts "It's there: #{@host.placeholder}"
    when :wrong_letter, :wrong_word
      print "Nope, that's not it! "
      puts "Incorrect guesses remaining: #{@incorrect_guesses_remaining}"
    when :correct_word
      puts "That's right!"
    when :invalid_input
      puts "That's neither a word nor a letter, try again."
    end
  end

  def print_outcome
    if game_won
      puts "Congratulations, you won! It was \"#{@host.placeholder}\""
    elsif game_lost 
      puts "You're out of wrong guesses... Game over."
    end
  end

end