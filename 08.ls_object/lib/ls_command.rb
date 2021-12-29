# frozen_string_literal: true

require_relative 'three_columns_display'
require_relative 'l_option'

class LsCommand
  def initialize(options)
    @long_listing_format = options[:long_listing_format]
    @reverse = options[:reverse]
    @dot_match = options[:dot_match]
  end

  def collect_files(file_path)
    files_from_directory = @dot_match ? Dir.glob('*', File::FNM_DOTMATCH, base: file_path) : Dir.glob('*', base: file_path)
    @reverse ? files_from_directory = files_from_directory.reverse : files_from_directory
    @long_listing_format ? l_option(files_from_directory, file_path) : three_columns_format(files_from_directory)
  end

  def three_columns_format(files_from_directory)
    matrix_files = ThreeColumnsDisplay.new(files_from_directory)
    matrix_files.build_file_matrix
  end

  def l_option(files_from_directory, file_path)
    file_details = LOption.new(files_from_directory, file_path)
    file_details.print_file_details
  end
end
