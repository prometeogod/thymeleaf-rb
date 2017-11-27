require 'oga'
require_relative '../../../sax_handler'
require_relative '../../../nodetree'
require_relative '../../../node_writer'
# UTextProcessor class definition : it process utext tag
class UTextProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, buffer: nil,**_)
    child_utext = EvalExpression.parse(context, attribute)
    
    handler = SaxHandler.new
    Oga.sax_parse_html(handler, child_utext)
    node.children.delete_at(0)
    childs = handler.nodes
    childs.each do |child|
      node.add_child(child)
    end
    node.mark
    node.mark_decendents
    node.attributes.delete('data-th-utext')
    write_buffer(node, child_utext, buffer)
    node
  end

  private 

  def write_buffer(node, child_utext, buffer)
    #NodeWriter.write_head(node)
    #NodeWriter.write(child_text)
    NodeWriter.write_head_buffer(buffer, node)
    NodeWriter.write_buffer(buffer, child_utext)
  end
end
