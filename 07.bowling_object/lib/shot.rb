# frozen_string_literal: true

class Shot
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def format_input
    inputs = @input.split(',')
    inputs.map { |i| i == 'X' ? 10 : i.to_i }
  end
end
