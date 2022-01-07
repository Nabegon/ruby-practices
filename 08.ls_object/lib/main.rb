# frozen_string_literal: true

require_relative 'ls_command'
require 'optparse'
require 'pathname'

opt = OptionParser.new

options = { long_listing_format: false, reverse: false, dot_match: false }
opt.on('-l') { |v| options[:long_listing_format] = v }
opt.on('-r') { |v| options[:reverse] = v }
opt.on('-a') { |v| options[:dot_match] = v }

opt.parse!(ARGV)

if __FILE__ == $PROGRAM_NAME
  file_path = File.expand_path(ARGV[0] || '')
  ls_command = LsCommand.new(options)
  puts ls_command.collect_files(file_path)
end
