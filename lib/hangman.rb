#!/usr/bin/env ruby

words = File.open("5desk.txt").readlines.map { |word| word.strip }.select { |word| word.length >= 5 && word.length <= 12 }
word = words.sample.downcase
letters = word.split("")
hidden_letters = letters.map { |letter| "_" }
guessed_letters = []
wrong_guesses = 0

game_over = false

until game_over
	p hidden_letters
	wrong_guess = true
	puts "Guess a letter (or type \"1\" to save your game): "
	begin
		guess = gets.chomp.downcase.match(/[a-z1]/)[0]
	rescue StandardError=>e
		puts "You can only guess a letter from a-z!"
		redo
	end

	#if guess == "1"
	#	save = File.open("saved_game.yaml", "w"){ |file| file.write(YAML::dump())}
	#end

	if guessed_letters.include? guess
		puts "You already guessed that letter"
		redo
	end

	if letters.include? guess
		wrong_guess = false
	  letters.each_with_index do |l, idx|
			if guess == l
				hidden_letters[idx] = l
			end
		end
	end

	guessed_letters.push(guess)
	wrong_guesses += 1 if wrong_guess

	puts "Guessed letters: #{guessed_letters}\nWrong Guesses: #{wrong_guesses}"

	if !hidden_letters.include? "_"
		puts "You correctly guessed the word, #{word}!"
		game_over = true
	end

	if wrong_guesses == 6
		puts "Too many wrong guesses, you're hanged!"
		puts "The word was: #{word}"
		game_over = true
	end
end

