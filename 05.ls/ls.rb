# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

FILE_TYPE_OPTIONS = {
  'file' => '-',
  'directory' => 'd',
  'link' => 'l'
}.freeze

PERMISSION_OPTIONS = {
  0 => '---',
  1 => '--x',
  2 => '-w-',
  3 => '-wx',
  4 => 'r--',
  5 => 'r-x',
  6 => 'rw-',
  7 => 'rwx'
}.freeze

def get_file_type(ftype_string)
  FILE_TYPE_OPTIONS.fetch(ftype_string)
end

def get_permission(permission_octal)
  permission_last_3_digits = (permission_octal % 1000).to_s
  last_3_digits_array = permission_last_3_digits.to_s.split('')

  permission_char = []
  last_3_digits_array.each do |n|
    permission_char << PERMISSION_OPTIONS[n.to_i]
  end
  permission_char.map(&:to_s).join('')
end

def load_file_details(corresponding_files_for_options_a_and_r, file_path)
  all_file_details = []
  sum_blocks = 0
  corresponding_files_for_options_a_and_r.each do |item|
    file_info = File.stat("#{file_path}/#{item}")

    each_block = file_info.blocks
    sum_blocks += each_block

    ftype_string = file_info.ftype
    file_type = get_file_type(ftype_string)

    permission_octal = format('%o', file_info.mode).to_i
    permission = get_permission(permission_octal)

    unformatted_link = file_info.nlink
    link = format('%2d', unformatted_link)

    user = Etc.getpwuid(file_info.uid).name.ljust(10)

    group = Etc.getgrgid(file_info.gid).name.ljust(10)

    unformatted_size = file_info.size
    size = format('%3d', unformatted_size)

    last_access_time = file_info.atime.to_s
    date = DateTime.parse(last_access_time)
    mon = date.strftime('%b')
    day = date.strftime('%1d')
    time = "#{date.strftime('%H')}:#{date.strftime('%M')}"

    all_file_details << "#{file_type + permission} #{link} #{user} #{group} #{size} #{mon} #{day} #{time} #{item}"
  end
  puts "total #{sum_blocks}"
  print_file_details(all_file_details)
end

def print_file_details(all_file_details)
  all_file_details.each { |each_line| puts each_line }
end

def put_files_into_2d_array(corresponding_files_for_options_a_and_r)
  max_length_string = corresponding_files_for_options_a_and_r.max_by(&:length).length

  left_justified_files = corresponding_files_for_options_a_and_r.map do |file_name|
    file_name.ljust(max_length_string + 1)
  end

  # use 3, because the max colmun is 3
  line_num = (left_justified_files.size % 3).zero? ? left_justified_files.size / 3 : left_justified_files.size / 3 + 1
  two_dimensional_array = left_justified_files.each_slice(line_num).map { |array| array }

  # to use transpose, insert nil if the size of the array is different
  max_size = two_dimensional_array.map(&:size).max
  two_dimensional_array.each do |list|
    if list.size < max_size
      num = max_size - list.size
      list.fill(nil, list.size, num)
    end
  end
  transposed_list = two_dimensional_array.transpose.map(&:flatten)

  print_files_in_3_clumns(transposed_list)
end

def print_files_in_3_clumns(transposed_list)
  transposed_list.each do |array|
    array.each do |each_file_name|
      print each_file_name.to_s
    end
    puts "\n"
  end
end

def load_files(file_path, option_a, option_l, option_r)
  sorted_files = []

  files_from_path = if option_a
                      Dir.glob('*', File::FNM_DOTMATCH, base: file_path)
                    else
                      Dir.glob('*', base: file_path)
                    end
  files_from_path.sort.each { |file| sorted_files << file }
  corresponding_files_for_options_a_and_r = option_r ? sorted_files.reverse : sorted_files
  if option_l
    load_file_details(corresponding_files_for_options_a_and_r,
                      file_path)
  else
    put_files_into_2d_array(corresponding_files_for_options_a_and_r)
  end
end

options = ARGV.getopts('alr')

option_a = options['a']
option_l = options['l']
option_r = options['r']

file_path = File.expand_path(ARGV[0] || '')

load_files(file_path, option_a, option_l, option_r)
