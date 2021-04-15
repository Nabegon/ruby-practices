# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COLUMN_COUNT = 3

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

def get_permission(permission_octal)
  last_3_digits = (permission_octal % 1000).to_s.chars

  last_3_digits.map do |n|
    PERMISSION_OPTIONS[n.to_i]
  end.join
end

def print_file_details(files, file_path)
  sum_blocks = 0
  file_details = files.map do |item|
    file_info = File.stat("#{file_path}/#{item}")
    sum_blocks += file_info.blocks
    file_type = FILE_TYPE_OPTIONS.fetch(file_info.ftype)
    permission = get_permission(format('%o', file_info.mode).to_i)
    link = format('%2d', file_info.nlink)
    user = Etc.getpwuid(file_info.uid).name.ljust(10)
    group = Etc.getgrgid(file_info.gid).name.ljust(10)
    size = format('%3d', file_info.size)
    date = file_info.atime
    mon = date.strftime('%b')
    day = date.strftime('%1d')
    time = "#{date.strftime('%H')}:#{date.strftime('%M')}"

    "#{file_type + permission} #{link} #{user} #{group} #{size} #{mon} #{day} #{time} #{item}"
  end
  puts "total #{sum_blocks}"
  file_details.each { |file_detail| puts file_detail }
end

def preprocessing_files(files)
  max_length_string = files.max_by(&:length).length

  formatted_files = files.map do |file_name|
    file_name.ljust(max_length_string + 1)
  end

  quo, rem = formatted_files.size.divmod(MAX_COLUMN_COUNT)
  line_num = rem.zero? ? quo : quo + 1
  file_matrix = formatted_files.each_slice(line_num).to_a

  # to use transpose, insert nil if the size of the array is different
  max_size = file_matrix.map(&:size).max
  file_matrix.each do |columns|
    if columns.size < max_size
      length = max_size - columns.size
      columns.fill(nil, columns.size, length)
    end
  end
  print_file_matrix(file_matrix)
end

def print_file_matrix(file_matrix)
  transposed_list = file_matrix.transpose
  transposed_list.each do |array|
    array.each do |each_file_name|
      print each_file_name.to_s
    end
    puts "\n"
  end
end

def load_files(file_path, option_a, option_l, option_r)
  files_from_path = if option_a
                      Dir.glob('*', File::FNM_DOTMATCH, base: file_path)
                    else
                      Dir.glob('*', base: file_path)
                    end
  sorted_files = option_r ? files_from_path.sort.reverse : files_from_path.sort
  option_l ? print_file_details(sorted_files, file_path) : preprocessing_files(sorted_files)
end

options = ARGV.getopts('alr')

option_a = options['a']
option_l = options['l']
option_r = options['r']

file_path = File.expand_path(ARGV[0] || '')

load_files(file_path, option_a, option_l, option_r)
