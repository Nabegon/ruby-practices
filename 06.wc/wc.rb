# frozen_string_literal: true

require 'optparse'

def show_help
  puts "The path or option doesn't exist. Please type correct path or option."
end

def print_calculated_results(_option_l, lines, words, bytes)
  [lines, words, bytes].each do |n|
    print n.to_s.rjust(8)
  end
  puts
end

def print_calculated_result_l(lines)
  puts lines.to_s.rjust(8)
end

def print_with_filename(l_num, w_num, c_num, input)
  puts "#{l_num} #{w_num} #{c_num} #{input}"
end

def print_lines_with_filename(l_num, input)
  puts "#{l_num} #{input}"
end

def get_file_nums(input, _option_l)
  l_num = w_num = c_num = 0
  File.readlines(input).each do |line|
    c_num += line.size
    line.chomp!
    l_num += 1
    w_num += line.split(/\s+/).count { |char| !char.empty? }
  end
  [l_num, w_num, c_num]
end

def calculate_all_data(str)
  lines = calculate_lines(str)
  words = calculate_words(str)
  bytes = calculate_bytes(str)
  [lines, words, bytes]
end

def calculate_lines(str)
  str.count("\n")
end

def calculate_words(str)
  str.split(/\s+/).size
end

def calculate_bytes(str)
  str.size
end

def print_sum_total(sum_l, sum_w, sum_c)
  puts "#{sum_l} #{sum_w} #{sum_c} total"
end

def print_sum_l(sum_l)
  puts "#{sum_l} total"
end

def check_file(input)
  puts "This file #{input} doesn't exist. Please type the correct file name" unless File.exist?(input)
end

begin
  options = ARGV.getopts('l')
rescue OptionParser::InvalidOption
  show_help
  exit(1)
end

option_l = options['l']
sum_l = sum_w = sum_c = 0
delta_l = delta_w = delta_c = 0

if !ARGV[0].nil?
  ARGV.each_with_index do |_arg, i|
    input = ARGV[i]
    delta_l, delta_w, delta_c = get_file_nums(input, option_l)
    option_l ? print_lines_with_filename(delta_l, input) : print_with_filename(delta_l, delta_w, delta_c, input)
    sum_l += delta_l
    sum_w += delta_w
    sum_c += delta_c
  end
  if sum_l != delta_l
    option_l ? print_sum_l(sum_l) : print_sum_total(sum_l, sum_w, sum_c)
  end
else
  str = $stdin.read
  lines, words, bytes = calculate_all_data(str)
  option_l ? print_calculated_result_l(lines) : print_calculated_results(option_l, lines, words, bytes)
end
