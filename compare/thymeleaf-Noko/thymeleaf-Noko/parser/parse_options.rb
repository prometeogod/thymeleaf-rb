
require 'nokogiri'
module ThymeleafNoko
class ParseOptions
  
  attr_accessor :encoding
  
  def initialize
    self.encoding = nil
  end
  
end
end