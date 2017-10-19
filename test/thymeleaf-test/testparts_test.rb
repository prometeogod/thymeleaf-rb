$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__),
                   File.expand_path('../../lib/thymeleaf_test', __FILE__)

require 'thymeleaf_test/testfile'

class TestPartsLibTest < TestThymeleafTestLib

  def load_thtest(test_name)
    file_content = File.open("files/#{test_name}.#{TEST_FILETYPE}").read
    file_content.split(TestFile::CONTENT_SEPARATOR)
  end

end