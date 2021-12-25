require_relative 'filelist'
require_relative 'three_columns_display'

class LsCommand
  def initialize(options)
    @long_listing_format = options[:long_listing_format]
    @reverse = options[:reverse]
    @dot_match = options[:dot_match]
  end

  def collect_files(file_path)
    if @dot_match
      files_from_directory = Dir.glob('*', File::FNM_DOTMATCH, base: file_path)
    else
      files_from_directory = Dir.glob('*', base: file_path)
    end
    @reverse ? files_from_directory = files_from_directory.reverse : files_from_directory
    files_from_directory.each {|file| file}
  end
end