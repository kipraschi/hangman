class Host
  def initialize
    @secret = random_word
    puts @secret
  end

  def random_word 
    File.readlines('lib/dictionary.txt')
      .select { |word| within_limits?(word.strip, 5, 12) }
      .sample
      .strip
  end

  def within_limits?(word, lower, upper)
    word.length >= lower && word.length <= upper
  end

end
