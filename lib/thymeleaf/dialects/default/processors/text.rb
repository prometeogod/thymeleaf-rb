require_relative '../../../nodetree'
require_relative '../../../node_writer'
require 'oga'
# TextProcessor class definition : it process escaped text in text tag
class TextProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, buffer: nil, **_)
    child_text = EvalExpression.parse(context, attribute)
    child_text = Oga::XML::Entities.encode(child_text)
    child = NodeTree.new('text-content', child_text)
    node.children.clear
    node.add_child(child)
    node.attributes.delete('data-th-text')
    # Precompile buffer
    if !node.marked?
      node.mark
      node.mark_decendents
      write_buffer(node, child_text, buffer)
    end
    #
    node
  end

  private 

  def write_buffer(node, child_text, buffer)
    NodeWriter.write_head_buffer(buffer, node)
    NodeWriter.write_buffer(buffer, child_text)
  end
end
