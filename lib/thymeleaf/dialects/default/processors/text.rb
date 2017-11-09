require_relative '../../../nodetree'
require 'oga'
# TextProcessor class definition : it process escaped text in text tag
class TextProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, **_)
    child_text = EvalExpression.parse(context, attribute)
    child_text = Oga::XML::Entities.encode(child_text)
    child = NodeTree.new('text-content', child_text)
    node.children.clear
    node.add_child(child)
    node.attributes.delete('data-th-text')
  end
end
