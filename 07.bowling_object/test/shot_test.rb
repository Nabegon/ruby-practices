# frozen_string_literal: true

require '/home/miki/ruby-practices/ruby-practices/07.bowling_object/shot'
require 'minitest/autorun'

class ShotTest < Minitest::Test
  def test_return_1
    shot = Shot.new('0')
    assert_equal 0, shot.score  
  end

  def test_return_2
    shot = Shot.new('9')
    assert_equal 9, shot.score
  end

  def test_return_3
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end
end