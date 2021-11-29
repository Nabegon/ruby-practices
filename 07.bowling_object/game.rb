# frozen_string_literal: true

require '/home/miki/ruby-practices/ruby-practices/07.bowling_object/frame'
require '/home/miki/ruby-practices/ruby-practices/07.bowling_object/shot'

class Game
  def initialize(input)
    @frames = Frame.new(input).divide_by_frames
    @score = 0
    p @frames
  end
  
  def score
    @frames.each_with_index do |frame, index|
      if is_strike?(frame)
        @score += if !@frames[index + 1].nil?
          10 + @frames[index + 1][0] + @frames[index + 1][1]
        else
          @frames[index].sum
        end
      elsif is_spare?(frame)
        @score += if !@frames[index + 1].nil?
                    10 + @frames[index + 1][0]
                  else
                    10
                  end
      elsif @frames[index + 1].nil? && (is_strike?(frame) || @frames[index].sum == 10)
        @score += frame.sum
      elsif !@frames[index + 1].nil?
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
end
=begin (0..9).each do |number|
      frame = @frames.slice(number)
      next_frame = @frames.slice(number + 1)
      after_next_frame = @frames.slice(number + 2)
      next_frame = [] if next_frame.nil?
      after_next_frame = [] if after_next_frame.nil?
      add_frame = next_frame + after_next_frame

      @score += if frame[0] == 10
        frame.sum + add_frame.slice(0, 2).sum
      elsif frame.sum == 10
        frame.sum + add_frame.slice(0)
      else
        frame.sum
      end
      @score
    end 
=end


game = Game.new('1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1')
puts game.score