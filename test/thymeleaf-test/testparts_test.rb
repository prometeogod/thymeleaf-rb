$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__),
                   File.expand_path('../../lib/thymeleaf_test', __FILE__)

require 'thymeleaf_test/testfile'
require 'test_helper'

class TestPartsLibTest < TestThymeleafTestLib

  def load_thtest(test_name)
    file_content = File.open("files/#{test_name}.#{TEST_FILETYPE}").read
    file_content.split(TestFile::CONTENT_SEPARATOR)
  end

  def test_context?
  	file = load_filetest 'valid_content'
  	testfile = ThymeleafTest::TestFile.new file
  	parts = testfile.send(:parts)
  	assert_equal parts.context?, true
  	refute_nil parts.context?
  end

  def test_th?
  	file = load_filetest 'valid_content'
  	testfile = ThymeleafTest::TestFile.new file
  	parts = testfile.send(:parts)
  	assert_equal parts.th?, true
  	refute_nil parts.th?
  end

   def test_expected?
  	file = load_filetest 'valid_content'
  	testfile = ThymeleafTest::TestFile.new file
  	parts = testfile.send(:parts)
  	assert_equal parts.expected?, true
  	refute_nil parts.expected?
  end

   def test_erb?
  	file = load_filetest 'valid_content'
  	testfile = ThymeleafTest::TestFile.new file
  	parts = testfile.send(:parts)
  	assert_equal parts.erb?, true
  	refute_nil parts.erb?
  end

end