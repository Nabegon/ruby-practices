# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  LAST_FRAME = 9

  def initialize(text)
    user_inputs = text.split(',')
    @frames = record_shots_to_frames(user_inputs)
  end

  def calculate_score
    @frames.each_with_index.sum do |frame, index|
      calculate_score_per_frame(frame, index)
    end
  end

  private

  def record_shots_to_frames(user_inputs)
    index = 0
    frames = []
    while frames.size < 10
      if frames.size == 9
        frames << Frame.new(*user_inputs[index, 3])
      elsif user_inputs[index] == 'X'
        frames << Frame.new(user_inputs[index])
        index += 1
      else
        frames << Frame.new(*user_inputs[index, 2])
        index += 2
      end
    end
    frames
  end

  def calculate_score_per_frame(frame, index)
    if index == LAST_FRAME
      frame.score
    elsif frame.strike?
      frame.score + add_bonus_strike_score(*@frames[index + 1, 2])
    elsif frame.spare?
      frame.score + @frames[index + 1].first_shot.score
    else
      frame.score
    end
  end

  def add_bonus_strike_score(first_frame, second_frame = nil)
    [first_frame.shots, second_frame&.shots].flatten.compact.first(2).sum(&:score)
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV[0])
  puts game.calculate_score
end
