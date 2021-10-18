# frozen_string_literal: true

require '/home/miki/ruby-practices/ruby-practices/07.bowling_object/shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot
  
  def initialize(first_pin, second_pin, third_pin = nil)
    @first_shot = Shot.new(first_pin).score
    @second_shot = Shot.new(second_pin).score
    @third_shot = Shot.new(third_pin).score
  end

  def score
    @first_shot + @second_shot
  end
end

# frame = Frame.new('1', '9')
# puts frame.first_shot
# puts frame.score 