require_relative '../../../utils/booleanize'

class UnlessProcessorSax
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, list:nil, **_)
    node.attributes.delete('data-th-unless')
    if booleanize EvalExpression.parse(context, attribute)
    	node.children.each{|child| node.children.delete(child)}
    	list.delete(node)
    end
  end
end