# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(inputs)
    @score = 0
    @inputs = inputs.split(',')
    @frames = []
  end

  def record_shots
    index = 0
    while index <= @inputs.size
      if @inputs[index] == 'X' 
        if !lastShot?(index)
          @frames << Frame.new(@inputs[index]) 
          index += 1
          #break
        else
          @frames << Frame.new(@inputs[index], @inputs[index + 1], @inputs[index + 2]) && break
          index += 1
        end
      elsif @inputs[index + 3].nil?
        @frames << Frame.new(@inputs[index], @inputs[index + 1], @inputs[index + 2]) && break
      else
        @frames << Frame.new(@inputs[index], @inputs[index + 1])
        index += 2
      end
    end
    @frames
  end 

  def score
    @frames.each_with_index do |frame, index|
      if frame.strike?
        p @frames[index + 1]
        p index
        if lastFrame?(index)
          @score += frame.score
        elsif @frames[index + 1].strike? && @frames[index + 2].strike?
          @score += frame.score + @frames[index + 1].score + @frames[index + 2].score
        elsif @frames[index + 1].strike? && !@frames[index + 2].strike?
          @score += frame.score + @frames[index + 1].score + @frames[index + 2].firstShot
        elsif @frames[index + 1].score >= 11
          @score += frame.score + @frames[index + 1].twoschots
        else
          @score += frame.score + @frames[index + 1].score
        end
        p @score
      elsif frame.spare?
        lastFrame?(index) ? @score += frame.score : @score += frame.score + @frames[index + 1].firstShot
        p @score
      else
        p @score += frame.score
      end
    end
    p @score
  end

  private
  
  def lastFrame?(index)
    @frames[index + 1].nil? 
  end

  def lastShot?(index)
    @inputs[index + 3].nil?
  end
end

if __FILE__ == $PROGRAM_NAME
  @game = Game.new(ARGV[0])
  @game.record_shots
  @game.score
end
