# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(input)
    @shots = Shot.new(input).format_input
  end

  def divide_by_frames
    frames = []
    frame = []

    @shots.each do |shot|
      frame << shot

      if frames.size < 10
        if frame.size >= 2 || shot == 10
          frames << frame.dup
          frame.clear
        end     
      else
        frames.last << shot
      end
    end
    frames
  end
end