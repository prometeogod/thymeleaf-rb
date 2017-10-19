module ThymeleafTest
  # TestParts class definition
  class TestParts
    PART_CONTEXT  = 0
    PART_TH       = 1
    PART_EXPECTED = 2
    PART_ERB      = 3

    attr_accessor :parts

    def initialize(parts)
      self.parts = parts
      self.parts.shift if prefix_section?(parts)
    end

    def context
      parts[PART_CONTEXT]
    end

    def th
      parts[PART_TH]
    end

    def expected
      parts[PART_EXPECTED]
    end

    def erb
      parts[PART_ERB]
    end

    def context?
      count >= PART_CONTEXT
    end

    def th?
      count >= PART_TH
    end

    def expected?
      count >= PART_EXPECTED
    end

    def erb?
      count >= PART_ERB
    end

    def count
      parts.count
    end

    def any?
      !empty?
    end

    def empty?
      count.zero?
    end

    private

    def prefix_section?(parts)
      parts.count > 3 && parts[0].empty?
    end
  end
end
