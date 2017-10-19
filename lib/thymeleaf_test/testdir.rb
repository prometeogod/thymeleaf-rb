require_relative 'testfile'

module ThymeleafTest
  # TestDir class definition
  class TestDir
    DEFAULT_TEST_FILETYPE = 'th.test'.freeze

    def self.find(dir = '**', test_filetype = DEFAULT_TEST_FILETYPE)
      Dir.glob("#{dir}/*.#{test_filetype}") do |file|
        yield TestFile.new file
      end
    end

    def self.find_erb(dir = '**', test_filetype = DEFAULT_TEST_FILETYPE)
      find(dir, test_filetype) do |file|
        next unless file.erb?
        yield file
      end
    end
  end
end
