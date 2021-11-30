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
      @score += if strike?(frame)
                  not_last_frame?(index) ? frame.sum + @frames[index + 1][0] + @frames[index + 1][1] : frame.sum
                elsif spare?(frame)
                  not_last_frame?(index) ? frame.sum + @frames[index + 1][0] : frame.sum
                else
                  frame.sum
                end
    end
    @score
  end

  private

  def strike?(frame)
    frame[0] == 10
  end

  def spare?(frame)
    frame.sum == 10
  end

  def not_last_frame?(index)
    !@frames[index + 1].nil?
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV[0])
  puts game.score
end
