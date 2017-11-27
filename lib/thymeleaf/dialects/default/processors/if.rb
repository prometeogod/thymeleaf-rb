require_relative '../../../utils/booleanize'
require_relative '../../../node_writer'
# IfProcessor class definition : it process if tags
class IfProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, list: nil, buffer: nil, **_)
    node.attributes.delete('data-th-if')
    return if booleanize EvalExpression.parse(context, attribute)
    node.mark
    node.children.clear
    node.attributes.clear
    list.delete(node)
    write_buffer(buffer)
  end

  private

  def write_buffer(buffer)
    NodeWriter.write_buffer(buffer,"\n")
  end
end
