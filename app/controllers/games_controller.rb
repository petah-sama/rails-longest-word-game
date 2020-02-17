require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    letters = params[:letters].gsub(' ', '').chars
    word = params[:word]
    letters_hash = Hash.new(0)
    letters.each { |letter| letters_hash[letter.upcase] += 1 }
    word.chars.each { |char| letters_hash[char.upcase] -= 1 }
    if letters_hash.values.all? { |value| value >= 0 }
      response = open("https://wagon-dictionary.herokuapp.com/#{word}").read
      dictionary = JSON.parse(response)
      dictionary['found'] ? @result = "Congratulations! #{word} is a valid english word!" : @result = "Sorry but #{word} is not a valid english word"
    else
      @result = "Sorry but #{word} can't be built of #{params[:letters]}"
    end
  end
end
