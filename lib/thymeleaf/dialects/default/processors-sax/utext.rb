require 'oga'
require_relative '../../../sax_handler'
require_relative '../../../nodetree'

class UTextProcessorSax
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    child_utext=EvalExpression.parse(context,attribute)
    handler = SaxHandler.new
    Oga.sax_parse_html(handler,child_utext)
    node.children.delete_at(0)
    childs=handler.nodes
    childs.each do |child|
    	node.add_child(child)
    end
    node.attributes.delete('data-th-utext')

  end
end