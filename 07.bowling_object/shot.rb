# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end
  
  def score
    marks = @mark.split(',')
    marks.each do |m|
      if m == 'X'
        return 10
      else
        return m.to_i
      end
    end
  end
end