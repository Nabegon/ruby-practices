# frozen_string_literal: true

class ThreeColumnsDisplay
  attr_reader :files

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
    printing_form(file_matrix.transpose)
  end

  def printing_form(matrix_files)
    max_length = matrix_files.flatten.compact.max_by(&:length).length
    matrix_files.map do |columns|
      render_short_format_row(columns, max_length)
    end.join("\n")
  end

  def render_short_format_row(columns, max_length)
    columns.map do |file_name|
      basename = file_name || ''
      basename.ljust(max_length + 1)
    end.join.rstrip
  end
end
