# frozen_string_literal: true

require '/home/miki/ruby-practices/ruby-practices/07.bowling_object/frame'
require 'minitest/autorun'

class FrameTest < Minitest::Test
  def test_return_1
    frame = Frame.new('0', '0')
    assert_equal 0, frame.score
  end

  def test_return_2
    frame = Frame.new('0', '9')
    assert_equal 9, frame.score
  end

  def test_return_3
    frame = Frame.new('1', '9')
    assert_equal 10, frame.score
  end

  def test_return_4
    frame = Frame.new('X', '0')
    assert_equal 10, frame.score
  end

  def test_return_5
    frame = Frame.new('X', '0')
    assert_equal 10, frame.score
  end
end