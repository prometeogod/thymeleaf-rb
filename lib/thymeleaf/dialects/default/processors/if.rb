require_relative '../../../utils/booleanize'
require_relative '../../../node_writer'
# IfProcessor class definition : it process if tags
class IfProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, list: nil, buffer: nil, **_)
    node.attributes.delete('data-th-if')
    return if booleanize EvalExpression.parse(context, attribute)
    # Node markup
    node.mark
    #
    node.children.clear
    node.attributes.clear
    list.delete(node)
    # Precompile buffer
    write_buffer(buffer)
    #
  end

  private

  def write_buffer(buffer)
    # NodeWriter.write_empty_line_buffer(buffer)
  end
end
