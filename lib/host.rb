class Host
  def initialize
    @secret = random_word
    @placeholder = create_placeholder
  end

  def update_placeholder(letter)
    letter_indexes = find_all_indexes(letter)
    unless letter_indexes.empty?
      letter_indexes.each do |index| 
        @placeholder[index] = @secret[index]
      end
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

  def find_all_indexes(guess)
    @secret
      .each_with_index
      .select do |letter, index|
        if letter == guess
          index
        end
      end
      .map { |letter, index| index }
  end

end
