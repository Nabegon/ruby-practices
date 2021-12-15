# frozen_string_literal: true

class Shot
  def initialize(input)
    @input = input
  end

  def score
    @input == 'X' ? 10 : @input.to_i
  end
end
