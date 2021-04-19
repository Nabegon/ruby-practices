# frozen_string_literal: true

require 'optparse'

def main
  options = check_option
  return if options.nil?

  option_l = options['l']
  sum_l = sum_w = sum_c = delta_l = delta_w = delta_c = 0

  if ARGV[0]
    ARGV.each_with_index do |_arg, i|
      input = ARGV[i]
      break unless check_file(input)

      delta_l, delta_w, delta_c = get_file_nums(input, option_l)
      print_with_filename(option_l, delta_l, delta_w, delta_c, input)
      sum_l += delta_l
      sum_w += delta_w
      sum_c += delta_c
    end
    print_sum_total(option_l, sum_l, sum_w, sum_c) if sum_l != delta_l
  else
    lines, words, bytes = calculate_all_data($stdin.read)
    print_calculated_results(option_l, lines, words, bytes)
  end
end

def check_option
  ARGV.getopts('l')
rescue OptionParser::InvalidOption
  show_help
end

def show_help
  puts "The path or option doesn't exist. Please type correct path or option."
end

def check_file(input)
  file_exist = File.exist?(input)
  puts "This file #{input} doesn't exist. Please type the correct file name" unless file_exist
  file_exist
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

def print_with_filename(option_l, l_num, w_num, c_num, input)
  puts(option_l ? "#{l_num} #{input}" : "#{l_num} #{w_num} #{c_num} #{input}")
end

def print_sum_total(option_l, sum_l, sum_w, sum_c)
  puts(option_l ? "#{sum_l} total" : "#{sum_l} #{sum_w} #{sum_c} total")
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

def print_calculated_results(option_l, lines, words, bytes)
  if option_l
    puts lines.to_s.rjust(8)
  else
    [lines, words, bytes].each do |n|
      print n.to_s.rjust(8)
    end
    puts
  end
end

main
