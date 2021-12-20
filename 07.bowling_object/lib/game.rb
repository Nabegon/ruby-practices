# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(inputs)
    @inputs = inputs.split(',')
    @frames = []
  end

  def record_shots
    index = 0
    while @frames.size < 10
      if @frames.size == 9
        @frames << Frame.new(@inputs[index], @inputs[index + 1], @inputs[index + 2])
      elsif @inputs[index] == 'X'
        @frames << Frame.new(@inputs[index])
        index += 1
      else
        @frames << Frame.new(@inputs[index], @inputs[index + 1])
        index += 2
      end
    end
  end

  def score
    record_shots
    total = @frames.each_with_index.sum do |frame, index|
      score_calculator(frame, index)
    end
  end

  private

  def score_calculator (frame, index)
      if last_frame?(index)
        frame.score
      elsif frame.strike?
        next_frame = @frames[index + 1]
        second_next_frame = @frames[index + 2]
        frame.score + add_bonus_strike_score(next_frame, second_next_frame)
      elsif frame.spare?
        frame.score + @frames[index + 1].first_shot
      else
        frame.score
      end
  end

  def add_bonus_strike_score(first_frame, second_frame)
    [first_frame.shots, second_frame&.shots].flatten.compact.first(2).sum
  end

  def last_frame?(index)
    @frames[index + 1].nil?
  end
end

if __FILE__ == $PROGRAM_NAME
  @game = Game.new(ARGV[0])
  p @game.score
end