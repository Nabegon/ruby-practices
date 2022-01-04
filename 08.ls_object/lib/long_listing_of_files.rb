# frozen_string_literal: true

require 'etc'

class LongListingOfFiles
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

  def initialize(files, file_path)
    @files = files
    @file_path = file_path
  end

  def collect_file_details
    sum_blocks = 0
    file_details = @files.map do |file|
      file_stat = File.stat("#{@file_path}/#{file}")
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
    total = "total #{sum_blocks}"
    file_details.unshift(total)
    file_details
  end

  private

  def get_permission(permission_octal)
    last_3_digits = (permission_octal % 1000).to_s.chars

    last_3_digits.map do |n|
      PERMISSION_OPTIONS[n.to_i]
    end.join
  end
end
