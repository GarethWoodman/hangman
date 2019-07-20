require 'yaml'

class Game
	attr_accessor :secret_word, :hidden_word, :turns, :guessed_letters

	def initialize
		file = File.open("words.txt")
		words = file.readlines.map(&:chomp)
		@secret_word = get_secret_word(words)
		@hidden_word = create_hidden_word(@secret_word)
		@guessed_letters = Array.new
		@guesses = @secret_word.length + 3
		puts "Enter S to save or L to load"
	end

	def play
		@guesses.times do |turn|
			@turns = @guesses-turn
			break if @turns < 1 
			puts "\n" + "Turns: #{@turns}"
			guessed_letter = gets.chomp
			return save_game if guessed_letter == "S"
			if guessed_letter == "L"
				load_game
				@guesses += 1
				next
			end

			if guessed_letter.length > 1 
				puts "Only one letter per turn"
				next
			end

			@guessed_letters << guessed_letter
			puts "Used Letters:" + @guessed_letters.join(" ")
			puts display_letters(guessed_letter)
			return win unless @hidden_word.include?("_")
		end
		lose
	end

	def save_game
		puts "Enter save name"
		file_name = gets.chomp
		File.open("saves/#{file_name}.yml", "w") { |file| file.write(self.to_yaml)}
	end

	def load_game
		puts "Load file"
		file_name = gets.chomp
		saved_state = YAML.load_file("saves/#{file_name}.yml", "w")
		@hidden_word = saved_state.hidden_word
		@secret_word = saved_state.secret_word
		@guessed_letters = saved_state.guessed_letters
		@guesses = saved_state.turns

		puts "Used Letters:" + @guessed_letters.join(" ")
		puts @hidden_word.join(" ")
	end

	private

	def get_secret_word(words)
		secret_words = Array.new
	  words.each { |word| secret_words << word if (word.length).between?(5,12) } 
	  random_word = rand(0..secret_words.length+1)
	  secret_words[random_word].chars
	end

	def create_hidden_word(secret_word)
		hidden_word = Array.new
	  (secret_word.length).times { hidden_word << "_" }
	  hidden_word
	end

	def display_letters(guessed_letter)
		guessed_letter = guessed_letter.downcase
		@secret_word.each_with_index do |letter, index| 
			@hidden_word[index] = letter if letter == guessed_letter
		end
		@hidden_word.join(" ")
	end

	def win
		puts "You win!"
	end

	def lose
		puts "You lose!"
	end
end

game = Game.new
game.play