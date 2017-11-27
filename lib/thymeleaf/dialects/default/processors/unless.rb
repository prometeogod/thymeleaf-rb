require_relative '../../../utils/booleanize'
require_relative '../../../node_writer'
# UnlessProcessor class definition : it process unless tag
class UnlessProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, list: nil, buffer: nil, **_)
    node.attributes.delete('data-th-unless')
    return unless booleanize EvalExpression.parse(context, attribute)
    node.children.clear
    node.attributes.clear
    node.mark
    list.delete(node)
    write_buffer(buffer)
  end

  private 

  def write_buffer(buffer)
  	NodeWriter.write_buffer(buffer, "\n") # TODO, Beware this \n
  end
end
