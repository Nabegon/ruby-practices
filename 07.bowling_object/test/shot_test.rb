# frozen_string_literal: true

require './lib/shot'
require 'minitest/autorun'

class ShotTest < Minitest::Test
  def test_pin_0
    shot = Shot.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
    assert_equal [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], shot.score  
  end

  def test_pin_1
    shot = Shot.new('1, 1, 1')
    assert_equal [1, 1, 1], shot.score
  end

  def test_strike_mark_convert_to_10
    shot = Shot.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10], shot.score
  end
end