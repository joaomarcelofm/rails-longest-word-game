require 'open-uri'
require 'json'

class WordsGameController < ApplicationController
  def game
    @grid = grid_generator
  end

  def score
    @start_time = params[:start_time].to_i
    @attempt = params[:query]
    @end_time = Time.now.to_i
    @grid = params[:grid_score]

    @result = run_game
  end

  protected

  def grid_generator
    grid = []

    @consonants = ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "X", "W", "Y", "Z"]
    @vowels = ["A", "E", "I", "O", "U"]

    6.times { |consonant| grid << @consonants.sample }
    4.times { |vowel| grid << @vowels.sample }

    grid.shuffle
  end

  def url_parser
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    attempt_text = open(url).read
    JSON.parse(attempt_text)
  end

  def grid_include
    array_word = @attempt.upcase.split(//)

    array_word.all? do |letter|
      @attempt.count(letter.downcase) <= @grid.count(letter)
    end
  end

  MESSAGE = { 1 => "A disaster!",
            2 => "Meeh!",
            3 => "You could have done better.",
            4 => "Still some work to do.",
            5 => "Getting better.",
            6 => "Good job!",
            7 => "Niiice!",
            8 => "Here we go!",
            9 => "Well done! Top result." }

  def run_game
  # TODO: runs the game and return detailed hash of result

  url_data = url_parser
  time = @end_time - @start_time
  score = (@attempt.size - (time / 1000))


    if grid_include && url_data["found"]
      { time: time, score: score, message: MESSAGE[score.round] }
    elsif url_data["found"] == false
      { time: time, score: 0, message: "not an english word" }
    else
      { time: time, score: 0, message: "not in the grid" }
    end
  end
end
