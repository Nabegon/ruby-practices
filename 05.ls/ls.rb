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

def main
  options = ARGV.getopts('alr')

  option_a = options['a']
  option_l = options['l']
  option_r = options['r']

  file_path = File.expand_path(ARGV[0] || '')

  files = find_files(file_path, option_a, option_l, option_r)
  option_l ? print_file_details(files, file_path) : print_file_matrix(files)
end

def find_files(file_path, option_a, _option_l, option_r)
  files_from_path = if option_a
                      Dir.glob('*', File::FNM_DOTMATCH, base: file_path)
                    else
                      Dir.glob('*', base: file_path)
                    end
  option_r ? files_from_path.sort.reverse : files_from_path.sort
end

def print_file_details(files, file_path)
  sum_blocks = 0
  file_details = files.map do |file|
    file_stat = File.stat("#{file_path}/#{file}")
    sum_blocks += file_stat.blocks
    file_type = FILE_TYPE_OPTIONS.fetch(file_stat.ftype)
    permission = get_permission(format('%o', file_stat.mode).to_i)
    link = format('%2d', file_stat.nlink)
    user = Etc.getpwuid(file_stat.uid).name.ljust(10)
    group = Etc.getgrgid(file_stat.gid).name.ljust(10)
    size = format('%3d', file_stat.size)
    date = file_stat.atime
    mon = date.strftime('%b')
    day = date.strftime('%1d')
    time = "#{date.strftime('%H')}:#{date.strftime('%M')}"

    "#{file_type + permission} #{link} #{user} #{group} #{size} #{mon} #{day} #{time} #{file}"
  end
  puts "total #{sum_blocks}"
  file_details.each { |file_detail| puts file_detail }
end

def get_permission(permission_octal)
  last_3_digits = (permission_octal % 1000).to_s.chars

  last_3_digits.map do |n|
    PERMISSION_OPTIONS[n.to_i]
  end.join
end

def print_file_matrix(files)
  file_matrix = build_file_matrix(files)
  max_length = file_matrix.flatten.compact.max_by(&:length).length

  file_matrix.each do |columns|
    columns.each do |file_name|
      next if file_name.nil?

      print file_name.ljust(max_length + 1)
    end
    puts "\n"
  end
end

def build_file_matrix(files)
  quo, rem = files.size.divmod(MAX_COLUMN_COUNT)
  line_num = rem.zero? ? quo : quo + 1
  file_matrix = files.each_slice(line_num).to_a

  # to use transpose, insert nil if the size of the array is different
  max_size = file_matrix.map(&:size).max
  file_matrix.each do |columns|
    length = max_size - columns.size
    columns.fill(nil, columns.size, length)
  end
  file_matrix.transpose
end

main
