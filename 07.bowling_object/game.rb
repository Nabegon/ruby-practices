# frozen_string_literal: true

require '/home/miki/ruby-practices/ruby-practices/07.bowling_object/frame'
require '/home/miki/ruby-practices/ruby-practices/07.bowling_object/shot'

class Game
  def initialize(input)
    @frames = Frame.new(input).divide_by_frames
    @score = 0
  end
  
  def score
    @frames.each_with_index do |frame, index|
      if is_strike?(frame)
        is_not_last_frame?(index) ? @score += frame.sum + @frames[index + 1].sum : @score += frame.sum
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

# game = Game.new('1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,X,1,1')
# puts game.score