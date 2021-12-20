# frozen_string_literal: true

class Shot
  def initialize(user_input)
    @user_input = user_input
  end

  def score
    @user_input == 'X' ? 10 : @user_input.to_i
  end

  def strike?
    @user_input == 'X'
  end
end
