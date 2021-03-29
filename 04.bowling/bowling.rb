# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  case s
  when 'X'
    shots << 10
    shots << 0
  when 'S'
    shots << 10
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  if frames.length == 9 && shots.length == 21
    frames << shots.last(3)
    break
  end
  frames << s
end

point = 0
frames.each_with_index do |frame, i|
  if frame[0] == 10 # strike
    point += if !frames[i + 1].nil?
               10 + frames[i + 1][0] + frames[i + 1][1]
             else
               frames[i].sum
             end
  elsif frames[i].sum == 10 # spare
    point += if !frames[i + 1].nil?
               10 + frames[i + 1][0]
             else
               10
             end
  elsif frames[i + 1].nil? && (frame[0] == 10 || frames[i].sum == 10)
    point += frame.sum
  elsif !frames[i + 1].nil?
    point += frame.sum
  end
end
puts point
