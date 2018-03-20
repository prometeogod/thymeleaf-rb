require 'oga'
require_relative 'sax_handler'
require_relative 'nodetree'

module Thymeleaf
  # Parser of the engine : using Oga
  class Parser < Struct.new(:template_markup)
    def call
      handler = SaxHandler.new
      Oga.sax_parse_html(handler, template_markup)
      nodes = handler.nodes
      root_node.append(nodes)
    end

    private 

    def root_node
      NodeTree.new('root')
    end
  end
end
