# frozen_string_literal: true

require_relative 'short_format'
require_relative 'long_format'

class LsCommand
  def initialize(options)
    @long_listing_format = options[:long_listing_format]
    @reverse = options[:reverse]
    @dot_match = options[:dot_match]
  end

  def collect_files(file_path)
    files_from_directory = @dot_match ? Dir.glob('*', File::FNM_DOTMATCH, base: file_path) : Dir.glob('*', base: file_path)
    @reverse ? files_from_directory = files_from_directory.reverse : files_from_directory
    format = @long_listing_format ? LongFormat.new(files_from_directory, file_path) : ShortFormat.new(files_from_directory)
    format.print
  end
end
