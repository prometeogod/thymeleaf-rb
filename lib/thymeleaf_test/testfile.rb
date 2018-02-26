
require_relative 'testparts'

module ThymeleafTest
  class WrongTestFileFormat < StandardError
  end
  # Testfile definition for Thymeleaf.rb : used to test the template engine
  class TestFile
    CONTENT_SEPARATOR = /^---\n/

    attr_writer :test_name

    def initialize(file)
      @file = file
    end

    def test_path
      file
    end

    def context?
      !parts.context.nil?
    end

    def erb?
      !parts.erb.nil?
    end

    def th?
      !parts.th.nil?
    end

    def expected?
      !parts.expected.nil?
    end

    def context
      eval(parts.context)
    end

    def th_template
      parts.th
    end

    def erb_template
      parts.erb
    end

    def expected_fragment
      parts.expected
    end

    def test_name(add_uniqueid = false)
      @test_name ||= begin
        test_name = if file.is_a? File
                      file.path.clone
                    else
                      file.to_s.clone
                    end
        test_name.gsub!(%r{[\/.]}, '_')
        test_name
      end
      if add_uniqueid == :add_uniqueid
        "#{@test_name}_#{uniqueid}"
      else
        @test_name
      end
    end

    def render_test
      th_template = self.th_template
      context = self.context
      Thymeleaf::Template.new(th_template, context).render
    end

    private

    attr_accessor :file

    def parts
      @parts ||= begin
        @file = File.open @file unless @file.is_a? File
        @file.rewind

        content = @file.read

        parts = TestParts.new content.split(CONTENT_SEPARATOR)
        @file = @file.path

        raise WrongTestFileFormat unless parts.any?
        parts
      end
    end

    def uniqueid
      now_f = Time.now.to_f
      now_i = now_f.to_s.delete('.').to_i
      now_i.to_s(36)
    end
  end
end
