require_relative '../../../utils/booleanize'
module ThymeleafNoko
class IfProcessor

  include ThymeleafNoko::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    attribute.unlink
    unless booleanize EvalExpression.parse(context, attribute.value)
      node.children.each {|child| child.unlink }
      node.unlink
    end
  end
end
end