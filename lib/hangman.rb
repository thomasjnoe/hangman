#!/usr/bin/env ruby
require "yaml"

WORDS = File.open("5desk.txt").readlines.map { |word| word.strip }.select { |word| word.length >= 5 && word.length <= 12 }

class Hangman
	attr_accessor :wrong_guesses

	def initialize
		@word = WORDS.sample.downcase
		@letters = word.split("")
		@hidden_letters = letters.map { |letter| "_" }
		@guessed_letters = []
		@wrong_guess = true
		@wrong_guesses = 0
		@game_over = false
	end

	def display_hidden_letters
		p hidden_letters
	end

	def already_guessed?(guess)
		guessed_letters.include?(guess)
	end

	def check_guess(guess)
		if guess == "1"
			puts "Saving game..."
			save_game
			puts "Game saved!"
		elsif guess == "2'"
			puts "Loading game..."
			Hangman.load_game
		elsif already_guessed?(guess)
			puts "You already guessed that letter"
		elsif letters.include?(guess)
		  letters.each_with_index do |l, idx|
				if guess == l
					hidden_letters[idx] = l
				end
			end
		else
			self.wrong_guess = true
		end
	end

	def add_guessed_letter(guess)
		guessed_letters.push(guess) if !guessed_letters.include?(guess)
	end

	def add_wrong_guess(guess)
		self.wrong_guesses += 1 if wrong_guess
	end

	def save_game
		save_data = YAML::dump(self)
		File.open("game_save.yaml","w"){ |file| file.write(save_data) }
	end

	def check_for_win_condition
		if !hidden_letters.include?("_")
			puts "You correctly guessed the word, #{word}!"
			self.game_over = true
		end
	end

	def check_for_loss_condition
		if wrong_guesses == 6
			puts "Too many wrong guesses, you're hanged!"
			puts "The word was: #{word}"
			self.game_over = true
		end
	end

	def self.load_game
		YAML.load_file("game_save.yaml").play
		exit
	end

	def play
		until game_over
			puts "\nGuessed letters: #{guessed_letters}\nWrong Guesses: #{wrong_guesses}"
			display_hidden_letters
			self.wrong_guess = false

			puts "\nGuess a letter (or type \"1\" to save your game, \"2\" to load your last saved game): "
			begin
				guess = gets.chomp.downcase.match(/[a-z12]/)[0]
			rescue StandardError=>e
				puts "You can only guess a letter from a-z!"
				prompt_for_guess
				redo
			end

			check_guess(guess)
			add_guessed_letter(guess)
			add_wrong_guess(guess)

			check_for_win_condition
			check_for_loss_condition
		end

	end

	private

	attr_accessor :words, :word, :letters, :hidden_letters, :guessed_letters, :wrong_guess, :game_over
end

hangman = Hangman.new
hangman.play


