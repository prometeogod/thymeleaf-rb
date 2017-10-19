require 'nokogiri'
# Parse options of the template engine
class ParseOptions
  attr_accessor :encoding
  def initialize
    self.encoding = nil
  end
end
