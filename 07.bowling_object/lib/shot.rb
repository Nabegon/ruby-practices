# frozen_string_literal: true

class Shot
  def initialize(input)
    @input = input
  end

  def score
    return 10 if @input == 'X'

    @input.to_i
  end
end
