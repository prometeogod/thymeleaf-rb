require_relative '../../../utils/booleanize'
# IfProcessor class definition : it process if tags
class IfProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, list: nil, **_)
    node.attributes.delete('data-th-if')

    return if booleanize EvalExpression.parse(context, attribute)
    node.children.clear
    list.delete(node)
  end
end
