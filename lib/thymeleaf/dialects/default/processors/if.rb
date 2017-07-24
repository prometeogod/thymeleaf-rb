require_relative '../../../utils/booleanize'

class IfProcessor

  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    attribute.unlink
    unless booleanize EvalExpression.parse(context, attribute.value)
      node.children.each {|child| child.unlink }
      node.unlink
    end
  
  end
end