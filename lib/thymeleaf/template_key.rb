require 'digest'
module Thymeleaf
  class TemplateKey
  	attr_reader :key
    def initialize(template)
      @key = Digest::SHA1.hexdigest(template)
    end
  end
end
