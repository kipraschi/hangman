class Host
  def initialize
    @secret = random_word
    @placeholder = create_placeholder
      end

attr_reader :placeholder

  def evaluate_guess(guess)
    if single_letter?(guess)
      if @secret.include?(guess) 
                :correct_letter 
      else
                :wrong_letter
      end
    elsif full_word?(guess)
      if guess == @secret.join 
        :correct_word
      else 
                :wrong_word
      end
    else
      :invalid_input
    end
  end
  
  private
  
  def random_word 
    File.readlines('lib/dictionary.txt')
    .select { |word| within_limits?(word.strip, 5, 12) }
    .sample
    .strip
    .chars
  end
  
  def within_limits?(word, lower, upper)
    word.length >= lower && word.length <= upper
  end
  
  def create_placeholder
    Array.new(@secret.length, "_").join
  end

  def update_placeholder(letter)
    letter_indexes = find_matching_indexes(letter)
    unless letter_indexes.empty?
      letter_indexes.each do |index| 
        @placeholder[index] = @secret[index]
      end
    end
  end
  
  def find_matching_indexes(guess)
    @secret
      .each_with_index
      .select do |letter, index|
        if letter == guess
          index
        end
      end
      .map { |letter, index| index }
  end

  def single_letter?(guess)
    guess.length == 1 && guess.match?(/[a-zA-Z]/)
  end

  def full_word?(guess)
    guess.count("^a-zA-Z").zero? && guess.size >= 2
  end
end
