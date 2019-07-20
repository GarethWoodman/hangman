#1. Read File
file = File.open("words.txt")
words = file.readlines.map(&:chomp)

#2. Get random word between 5 and 12 characters long
def get_secret_word(words)
	secret_words = Array.new
  words.each { |word| secret_words << word if (word.length).between?(5,12) } 
  random_word = rand(0..secret_words.length+1)
  secret_words[random_word].chars
end

#3. Create hidden word
def create_hidden_word(secret_word)
	hidden_word = Array.new
  (secret_word.length).times { hidden_word << "_" }
  hidden_word
end

def display_letters(secret_word, hidden_word, guessed_letter)
	secret_word.each_with_index do |letter, index| 
		hidden_word[index] = letter if letter == guessed_letter
	end
	hidden_word.join(" ")
end

secret_word = get_secret_word(words)
hidden_word = create_hidden_word(secret_word)

#4. Allow player to input guess
guesses = 12

guesses.times do |turn|
	puts guesses-turn
	guessed_letter = gets.chomp
	puts display_letters(secret_word, hidden_word, guessed_letter)
end
