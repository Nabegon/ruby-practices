# frozen_string_literal: true

require 'optparse'
require 'etc'

def get_file_type(temp_ftype)
  file_type_opt = {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l'
  }
  file_type_opt.fetch(temp_ftype)
end

def get_permission(temp_permission)
  nums = (temp_permission % 1000).to_s
  nums_array = nums.to_s.split('')
  list_options = {
    0 => '---',
    1 => '--x',
    2 => '-w-',
    3 => '-wx',
    4 => 'r--',
    5 => 'r-x',
    6 => 'rw-',
    7 => 'rwx'
  }
  convert_permission = []
  nums_array.each do |n|
    convert_permission << list_options[n.to_i]
  end
  convert_permission.map { |i| "'#{i}'" }.join('')
  convert_permission
end

# ls -l
def option_l(list, path, opt_r)
  array_file_info = []
  sum_blocks = 0
  list.sort.each do |item|
    file_info = File.stat("#{path}/#{item}")

    each_block = file_info.blocks
    sum_blocks += each_block

    temp_ftype = file_info.ftype
    file_type = get_file_type(temp_ftype)

    temp_permission = format('0%o', file_info.mode).to_i
    permission = get_permission(temp_permission).join

    link = file_info.nlink
    right_link = format('%2d', link)

    temp_user = Etc.getpwuid(file_info.uid).name
    user = temp_user.ljust(10)

    temp_group = Etc.getgrgid(file_info.gid).name
    group = temp_group.ljust(10)

    size = file_info.size
    r_size = format('%3d', size)

    list_time = file_info.atime.to_a
    t = Time.gm(list_time[4])
    mon = t.strftime('%b')
    day = format('%1d', list_time[3])
    time = "#{list_time[2]}:#{list_time[1]}"

    array_file_info << "#{file_type + permission} #{right_link} #{user} #{group} #{r_size} #{mon} #{day} #{time} #{item}"
  end
  puts "total #{sum_blocks}"
  print_file_details(opt_r, array_file_info)
end

def print_file_details(opt_r, array_file_info)
  if !opt_r
    array_file_info.each do |a|
      puts a
    end
  else
    array_file_info.reverse_each do |a|
      puts a
    end
  end
end

def show_files(list, opt_r)
  column_size = 3

  max_file_name = list.max_by(&:length)
  max_leng = max_file_name.length

  new_list = list.map { |x| x.ljust(max_leng) }

  case new_list.size % column_size
  when 1
    2.times { new_list.push(nil) }
  when 2
    new_list.push(nil)
  end

  if new_list.size <= 4
    new_list
  elsif new_list.size <= 8
    slice_lists = new_list.each_slice(new_list.size / 2).to_a
    trans_lists = slice_lists.transpose
  else
    slice_lists = new_list.each_slice(new_list.size / column_size).to_a
    trans_lists = slice_lists.transpose
  end
  print_files(opt_r, trans_lists, new_list)
end

def print_files(opt_r, trans_lists, new_list)
  if !opt_r
    if trans_lists
      trans_lists.each do |row|
        puts row.join(' ')
      end
    else
      puts new_list
    end
  elsif trans_lists
    trans_lists.each do |row|
      puts row.join(' ')
    end
  else
    new_list.each do |row|
      puts row
    end
  end
end

def get_files(path, opt_a, opt_l, opt_r)
  temp_list = []
  Dir.foreach(path).sort.each do |item|
    next if !opt_a && (item == '.' || item == '..' || item.start_with?('.'))

    temp_list << item
  end
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

