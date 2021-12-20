# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @shots = []
    @shots << Shot.new(first_shot)
    @shots << Shot.new(second_shot) if second_shot
    @shots << Shot.new(third_shot) if third_shot
  end

  def score
    @shots.sum(&:score)
  end

  def shots
    @shots.map(&:score)
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && @shots.first(2).sum(&:score).spare?
  end

  def first_shot
    @shots[0].score
  end
end
