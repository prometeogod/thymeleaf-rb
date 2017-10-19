require_relative '../../../utils/booleanize'
# UnlessProcessor class definition : it process unless tag
class UnlessProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, list: nil, **_)
    node.attributes.delete('data-th-unless')
    return unless booleanize EvalExpression.parse(context, attribute)
    node.children.clear
    list.delete(node)
  end
end
