# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(input)
    @frames = Frame.new(input).divide_by_frames
    @score = 0
  end
  
  def score
    @frames.each_with_index do |frame, index|
      if is_strike?(frame)
        is_not_last_frame?(index) ? @score += frame.sum + @frames[index + 1][0] + @frames[index + 1][1] : @score += frame.sum
      elsif is_spare?(frame)
        is_not_last_frame?(index) ? @score += frame.sum + @frames[index + 1][0] : @score += frame.sum
      else
        @score += frame.sum
      end
    end
    @score
  end
  
  private
  def is_strike?(frame)
    frame[0] == 10
  end

  def is_spare?(frame)
    frame.sum == 10
  end

  def is_not_last_frame?(index)
    !@frames[index + 1].nil?
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV[0])
  puts game.score
end