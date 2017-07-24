require 'oga'
require_relative 'sax_handler'

module Thymeleaf

  class ParserSax < Struct.new(:template_markup)
    def call
      handler = SaxHandler.new
      if /^\s*(?:\s*<!--[^>]*-->)*\s*<(?:html|!doctype)/i.match(template_markup)
        Oga.sax_parse_html(handler,template_markup)
      else
        Oga.sax_parse_html(handler,template_markup)
      end
      handler
    end
  end

end