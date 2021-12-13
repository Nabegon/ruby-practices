# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot)
    @third_shot = Shot.new(third_shot)
  end

  def score
    if @second_shot.nil? && @third_shot.nil?
      @first_shot.score
    elsif @third_shot.nil?
      @first_shot.score + @second_shot.score
    else
      @first_shot.score + @second_shot.score + @third_shot.score
    end
  end

  def spare?
    @first_shot.score + @second_shot.score == 10
  end

  def calcStrike
    if @second_shot.nil?
      @first_shot.score
    else
      @first_shot.score + @second_shot.score
    end 
  end

  def firstShot
    @first_shot.score
  end

  def strike?
    @first_shot.score == 10
  end

  def twoschots
    @first_shot.score + @second_shot.score
  end
end
