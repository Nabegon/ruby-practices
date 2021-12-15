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
    while index < @inputs.size
      if @inputs[index] == 'X'
        @frames << Frame.new(@inputs[index])
        index += 1
      else
        @frames << Frame.new(@inputs[index], @inputs[index + 1])
        index += 2
      end
      if @frames.size == 9
        @frames << Frame.new(@inputs[index], @inputs[index + 1], @inputs[index + 2])
        break
      end
    end
  end

  def score
    record_shots
    @frames.each_with_index do |frame, index|
      @score +=
        if last_frame?(index)
          frame.score
        elsif frame.strike?
          if one_before_last_frame?(index)
            frame.score + add_bonus_strike_score_last_frame(index)
          else
            frame.score + add_bonus_strike_score(index).sum
          end
        elsif frame.spare?
          frame.score + @frames[index + 1].first_shot
        else
          frame.score
        end
    end
    p @score
  end

  private

  def add_bonus_strike_score(index)
    shots = []
    shots << [*@frames[index + 1].shots, *@frames[index + 2]&.shots].compact
    shots.first(2)
    shots.inject(:+)
  end

  def add_bonus_strike_score_last_frame(index)
    if @frames[index + 1].three_shots?
      @frames[index + 1].first_shot + @frames[index + 1].second_shot
    else
      @frames[index + 1].score
    end
  end

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
  @game.score
end
