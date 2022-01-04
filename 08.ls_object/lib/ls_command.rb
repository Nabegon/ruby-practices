# frozen_string_literal: true

require_relative 'listed_files'
require_relative 'long_listing_of_files'

class LsCommand
  def initialize(options)
    @long_listing_format = options[:long_listing_format]
    @reverse = options[:reverse]
    @dot_match = options[:dot_match]
  end

  def collect_files(file_path)
    files_from_directory = @dot_match ? Dir.glob('*', File::FNM_DOTMATCH, base: file_path) : Dir.glob('*', base: file_path)
    @reverse ? files_from_directory = files_from_directory.reverse : files_from_directory
    @long_listing_format ? long_format(files_from_directory, file_path) : short_format(files_from_directory)
  end

  private

  def short_format(files_from_directory)
    listed_files = ListedFiles.new(files_from_directory)
    listed_files.build_file_matrix
  end

  def long_format(files_from_directory, file_path)
    long_listing_of_files = LongListingOfFiles.new(files_from_directory, file_path)
    long_listing_of_files.collect_file_details
  end
end
