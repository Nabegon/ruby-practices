# frozen_string_literal: true

require './lib/frame'
require 'minitest/autorun'

class FrameTest < Minitest::Test
  def test_return_0
    frame = Frame.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
    assert_equal 0, frame.score
  end

  def test_add_numbers
    frame = Frame.new('1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1')
    assert_equal 20, frame.score
  end

  def test_add_strikes
    frame = Frame.new('X,X,X')
    assert_equal 30, frame.score
  end
end