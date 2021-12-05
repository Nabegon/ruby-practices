class FileList
  def initialize(file_path)
    @file_path = file_path
  end

  def find_files
    files_from_directory = Dir.glob('*', base: @file_path)
  end
end