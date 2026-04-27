class Player
  def take_action
    print "Type a letter or a word to make your guess: "
    gets.chomp.downcase.strip
  end
end