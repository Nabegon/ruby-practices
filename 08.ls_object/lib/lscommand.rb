require_relative 'filelist'

class LsCommand
  def initialize(file_path)
    @files = FileList.new(file_path).find_files
  end

  def print
    @files.each do |file|
      puts file
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  file_path = File.expand_path(ARGV[0] || '')
  lsCommand = LsCommand.new(file_path)
  lsCommand.print
end