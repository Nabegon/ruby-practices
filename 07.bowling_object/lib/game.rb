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
        if !last_shot?(index)
          @frames << Frame.new(@inputs[index])
          # break
        else
          @frames << Frame.new(@inputs[index], @inputs[index + 1], @inputs[index + 2]) && break
        end
        index += 1
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
      @score += if last_frame?(index)
                  frame.score
                elsif frame.strike?
                  if one_before_last_frame?(index)
                    if @frames[index + 1].three_shots?
                      frame.score + @frames[index + 1].first_shot + @frames[index + 1].second_shot
                    else
                      frame.score + @frames[index + 1].score
                    end
                  elsif two_before_last_frame?(index) && @frames[index + 1].strike? && @frames[index + 2].strike? || @frames[index + 2].spare?
                    frame.score + @frames[index + 1].score + @frames[index + 2].first_shot
                  elsif @frames[index + 1].strike? && @frames[index + 2].strike?
                    frame.score + @frames[index + 1].score + @frames[index + 2].score
                  elsif @frames[index + 1].first_shot == 10 && @frames[index + 2].first_shot != 10
                    frame.score + @frames[index + 1].score + @frames[index + 2].first_shot
                  elsif @frames[index + 1].spare?
                    frame.score + @frames[index + 1].score
                  else
                    frame.score + @frames[index + 1].score
                  end
                elsif frame.spare?
                  frame.score + @frames[index + 1].first_shot
                else
                  frame.score
                end
    end
    @score
  end

  private

  def last_frame?(index)
    @frames[index + 1].nil?
  end

  def last_shot?(index)
    @inputs[index + 3].nil?
  end

  def one_before_last_frame?(index)
    @frames[index + 2].nil?
  end

  def two_before_last_frame?(index)
    @frames[index + 3].nil?
  end
end

if __FILE__ == $PROGRAM_NAME
  @game = Game.new(ARGV[0])
  @game.record_shots
  @game.score
end
