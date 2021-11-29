# frozen_string_literal: true

require '/home/miki/ruby-practices/ruby-practices/07.bowling_object/shot'

class Frame
  def initialize(input)
    @shots = Shot.new(input).format_input
  end

  def divide_by_frames
    frames = []
    frame = []

    @shots.each do |shot|
      frame << shot

      if frames.size < 10 # 1 to 9
        if frame.size >= 2 || shot == 10
          frames << frame.dup
          frame.clear
        end     
      else
        frames.last << shot # why do i need this?
      end
    end
    frames
  end
end

frame = Frame.new('1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1')
frame.divide_by_frames 