# frozen_string_literal: true

class Shot
  attr_reader :pin

  def initialize(pin)
    @pin = pin
  end
  
  def score
    if @pin == 'X'
      return 10
    end

    @pin.to_i
  end
end

# shot = Shot.new('9')
# puts shot.score

=begin
class Shot
  def score(input)
    if input == 'X'
      return '10'
    else
      return input
    end
  end
end

shot = Shot.new
puts shot.score('9')
=end
