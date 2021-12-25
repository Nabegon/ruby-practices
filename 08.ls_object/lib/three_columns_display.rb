require_relative 'filelist'
require_relative 'ls_command'

class ThreeColumnsDisplay
  MAX_COLUMN_COUNT = 3

  def initialize(files)
    @files = files
  end
  
  def build_file_matrix
    quo, rem = @files.size.divmod(MAX_COLUMN_COUNT)
    line_num = rem.zero? ? quo : quo + 1
    file_matrix = @files.each_slice(line_num).to_a

    max_size = file_matrix.map(&:size).max
    file_matrix.each do |columns|
      length = max_size - columns.size
      columns.fill(nil, columns.size, length)
    end
    file_matrix.transpose
  end
end
