# frozen_string_literal: true

require '/home/miki/ruby-practices/ruby-practices/07.bowling_object/game'
require 'minitest/autorun'

class GameTest < Minitest::Test
  def test_pin_0
    game = Game.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
    assert_equal 0, game.score  
  end

  def test_pin_1
    game = Game.new('1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1')
    assert_equal 20, game.score
  end

  def test_spare
    game = Game.new('9,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1')
    assert_equal 29, game.score
  end

  def test_strike
    game = Game.new('X,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1')
    assert_equal 30, game.score
  end

  def test_strike_last_frame
    game = Game.new('1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,X,1,1')
    assert_equal 30, game.score
  end

  def test_spare_last_frame
    game = Game.new('1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5,1')
    assert_equal 29, game.score
  end
end