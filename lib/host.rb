class Host
  def initialize
    @secret = random_word
    @placeholder = create_placeholder
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

end
