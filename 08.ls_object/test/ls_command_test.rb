# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_command'

class LsCommandTest < Minitest::Test
  TARGET_PATHNAME = File.expand_path('test/sample-app')

  def test_run_ls_no_options
    options = { long_listing_format: false, reverse: false, dot_match: false }
    ls = LsCommand.new(options)
    expected = <<~TEXT.chomp
      file1.rb file3.rb test
      file2.rb file4.rb test2
    TEXT
    assert_equal expected, ls.collect_files(TARGET_PATHNAME)
  end

  def test_run_ls_a_option
    options = { long_listing_format: false, reverse: false, dot_match: true }
    ls = LsCommand.new(options)
    expected = <<~TEXT.chomp
      .        file2.rb test
      ..       file3.rb test2
      file1.rb file4.rb
    TEXT
    assert_equal expected, ls.collect_files(TARGET_PATHNAME)
  end

  def test_run_ls_r_option
    options = { long_listing_format: false, reverse: true, dot_match: false }
    ls = LsCommand.new(options)
    expected = <<~TEXT.chomp
      test2    file4.rb file2.rb
      test     file3.rb file1.rb
    TEXT
    assert_equal expected, ls.collect_files(TARGET_PATHNAME)
  end

  def test_run_ls_l_option
    options = { long_listing_format: true, reverse: false, dot_match: false }
    ls = LsCommand.new(options)
    expected = <<~TEXT.chomp
      total 8
      -rw-r--r--  1 miki       miki        36 Dec 29 20:36 file1.rb
      -rw-r--r--  1 miki       miki        36 Dec 29 20:36 file2.rb
      -rw-r--r--  1 miki       miki        36 Dec 29 20:36 file3.rb
      -rw-r--r--  1 miki       miki        36 Dec 29 20:36 file4.rb
      drwxr-xr-x  2 miki       miki       4096 Dec 29 15:36 test
      drwxr-xr-x  2 miki       miki       4096 Dec 29 15:36 test2
    TEXT
    assert_output("#{expected}\n") { puts ls.collect_files(TARGET_PATHNAME) }
  end

  def test_run_ls_all_options
    options = { long_listing_format: true, reverse: true, dot_match: true }
    ls = LsCommand.new(options)
    expected = <<~TEXT.chomp
      total 8
      drwxr-xr-x  2 miki       miki       4096 Dec 29 15:36 test2
      drwxr-xr-x  2 miki       miki       4096 Dec 29 15:36 test
      -rw-r--r--  1 miki       miki        36 Dec 29 20:36 file4.rb
      -rw-r--r--  1 miki       miki        36 Dec 29 20:36 file3.rb
      -rw-r--r--  1 miki       miki        36 Dec 29 20:36 file2.rb
      -rw-r--r--  1 miki       miki        36 Dec 29 20:36 file1.rb
      drwxr-xr-x  3 miki       miki       4096 Dec 29 18:44 ..
      drwxr-xr-x  4 miki       miki       4096 Dec 29 20:36 .
    TEXT
    assert_output("#{expected}\n") { puts ls.collect_files(TARGET_PATHNAME) }
  end
end
