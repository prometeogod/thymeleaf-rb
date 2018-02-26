require 'oga'
require_relative 'sax_handler'

module Thymeleaf
  # Parser of the engine : using Oga
  class Parser < Struct.new(:template_markup)
    def call
      handler = SaxHandler.new
      Oga.sax_parse_html(handler, template_markup)
      handler.nodes
    end
  end
end
