# frozen_string_literal: true

require 'optparse'

def show_help
  puts "The path or option doesn't exist. Please type correct path or option."
  exit
end

def print_all(opt_l, lines, words, bytes)
  if opt_l
    puts lines.to_s.rjust(8)
  else
    [lines, words, bytes].each do |n|
      print n.to_s.rjust(8)
    end
    puts
  end
end

def print_with_filename(opt_l, l_num, w_num, c_num, input)
  if opt_l
    puts "#{l_num} #{input}"
  else
    puts "#{l_num} #{w_num} #{c_num} #{input}"
  end
end

def check_files(input)
  return if File.exist?(input)

  puts "This file #{input} doesn't exist. Please type the correct file name"
  exit
end

def get_file_nums(input, opt_l)
  check_files(input)
  l_num = w_num = c_num = 0
  File.readlines(input).each do |line|
    c_num += line.size

    line.chomp!
    l_num += 1

    words = line.split(/\s+/).reject(&:empty?)
    w_num += words.size
  end

  print_with_filename(opt_l, l_num, w_num, c_num, input)
  [l_num, w_num, c_num]
end

def load_all_data(opt_l, str)
  lines = load_lines(str)
  words = load_words(str)
  bytes = load_bytes(str)
  print_all(opt_l, lines, words, bytes)
end

def load_lines(str)
  str.count("\n")
end

def load_words(str)
  str.split(/\s+/).size
end

def load_bytes(str)
  str.size
end

def print_sum_total(opt_l, sum_l, sum_w, sum_c)
  if opt_l
    puts "#{sum_l} total"
  else
    puts "#{sum_l} #{sum_w} #{sum_c} total"
  end
end

error = OptionParser::InvalidOption
begin
  options = ARGV.getopts('l')
rescue error
  show_help
end

opt_l = options['l']

file_name = ARGV[0]

sum_l = sum_w = sum_c = 0
delta_l = delta_w = delta_c = 0

if !file_name.nil?
  ARGV.each_with_index do |_arg, i|
    input = ARGV[i]
    delta_l, delta_w, delta_c = get_file_nums(input, opt_l)
    sum_l += delta_l
    sum_w += delta_w
    sum_c += delta_c
  end
  print_sum_total(opt_l, sum_l, sum_w, sum_c) if sum_l != delta_l
else
  str = $stdin.read
  load_all_data(opt_l, str)
end
