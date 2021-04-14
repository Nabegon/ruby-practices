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

def get_file_type(temp_ftype)
  FILE_TYPE_OPTIONS.fetch(temp_ftype)
end

def get_permission(temp_permission)
  nums = (temp_permission % 1000).to_s
  nums_array = nums.to_s.split('')

  convert_permission = []
  nums_array.each do |n|
    convert_permission << PERMISSION_OPTIONS[n.to_i]
  end
  convert_permission.map(&:to_s).join('')
end

def option_l(list, path, _opt_r)
  array_file_info = []
  sum_blocks = 0
  list.each do |item|
    file_info = File.stat("#{path}/#{item}")

    each_block = file_info.blocks
    sum_blocks += each_block

    temp_ftype = file_info.ftype
    file_type = get_file_type(temp_ftype)

    temp_permission = format('%o', file_info.mode).to_i
    permission = get_permission(temp_permission)

    link = file_info.nlink
    right_link = format('%2d', link)

    user = Etc.getpwuid(file_info.uid).name.ljust(10)

    group = Etc.getgrgid(file_info.gid).name.ljust(10)

    size = file_info.size
    r_size = format('%3d', size)

    last_access_time = file_info.atime.to_s
    date = DateTime.parse(last_access_time)
    mon = date.strftime('%b')
    day = date.strftime('%1d')
    time = "#{date.strftime('%H')}:#{date.strftime('%M')}"

    array_file_info << "#{file_type + permission} #{right_link} #{user} #{group} #{r_size} #{mon} #{day} #{time} #{item}"
  end
  puts "total #{sum_blocks}"
  print_file_details(array_file_info)
end

def print_file_details(array_file_info)
  array_file_info.each { |a| puts a }
end

def show_files(list, _opt_r)
  max_leng = list.max_by(&:length).length

  new_list = list.map { |x| x.ljust(max_leng + 1) }

  size_array = (new_list.size % 3).zero? ? new_list.size / 3 : new_list.size / 3 + 1
  sliced_list = new_list.each_slice(size_array).map { |n| n }
  trans_lists = sliced_list.reduce(&:zip).map(&:flatten)

  print_files(trans_lists)
end

def print_files(trans_lists)
  trans_lists.each do |array|
    array.each do |display|
      print display.to_s
    end
    puts "\n"
  end
end

def get_files(path, opt_a, opt_l, opt_r)
  temp_list = []

  temp_files = if opt_a
                 Dir.glob('*', File::FNM_DOTMATCH, base: path)
               else
                 Dir.glob('*', base: path)
               end

  temp_files.sort.each { |fn| temp_list << fn }
  list = opt_r ? temp_list.reverse : temp_list
  opt_l ? option_l(list, path, opt_r) : show_files(list, opt_r)
end

def show_help
  puts "The path or option doesn't exist. Please type correct path or option."
  exit
end

input_index = 0

input = ARGV

begin
  options = ARGV.getopts('alr')
rescue OptionParser::InvalidOption
  show_help
end
opt_a = options['a']
opt_l = options['l']
opt_r = options['r']

temp_path = input.at(input_index).to_s

path = File.expand_path(temp_path || '')

show_help unless File.exist?(path)

get_files(path, opt_a, opt_l, opt_r)
