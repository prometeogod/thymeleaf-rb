require 'oga'
require_relative 'sax_handler'

module Thymeleaf
  # Parser of the engine : using Oga
  class Parser < Struct.new(:template_markup)
    def call
      handler = SaxHandler.new
      Oga.sax_parse_html(handler, template_markup)
      # regexp=@r{/^\s*(?:\s*<!--[^>]*-->)*\s*<(?:html|!doctype)/i}
      # if regexp.match(template_markup)
      #   Oga.sax_parse_html(handler, template_markup)
      # else
      #   Oga.sax_parse_html(handler, template_markup)
      # end
      handler.nodes
    end
  end
end
