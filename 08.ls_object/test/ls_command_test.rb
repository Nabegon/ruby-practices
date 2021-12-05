require 'minitest/autorun'
require './lib/lscommand'

class LsCommandTest < Minitest::Test
  TARGET_PATHNAME = File.expand_path('test/sample-app')

  def test_run_ls_no_options_no_three_colums_display
    ls = LsCommand.new(TARGET_PATHNAME)
    assert_equal ["file1.rb", "file2.rb", "file3.rb", "file4.rb", "test", "test2"], ls.print
  end
end