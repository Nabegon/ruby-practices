# frozen_string_literal: true

require '/home/miki/ruby-practices/ruby-practices/07.bowling_object/shot'

class Frame
  attr_reader :shots

  def initialize(input)
    @shots = Shot.new(input).score
    @sum = 0
  end
  
  def score
    @shots.each do |s|
      @sum += s
    end
    @sum
  end
end