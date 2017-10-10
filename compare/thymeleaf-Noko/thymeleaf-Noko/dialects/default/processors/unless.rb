require_relative '../../../utils/booleanize'
module ThymeleafNoko
class UnlessProcessor
  include ThymeleafNoko::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    attribute.unlink
    if booleanize EvalExpression.parse(context, attribute.value)
      node.children.each {|child| child.unlink }
      node.unlink
    end
  end
end
end