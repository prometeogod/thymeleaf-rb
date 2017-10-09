require_relative '../../../utils/booleanize'

class IfProcessor

  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, list:nil, **_)
    node.attributes.delete('data-th-if')
    unless booleanize EvalExpression.parse(context, attribute)
    	node.children.each {|child| node.children.delete(child)}
    	list.delete(node)
    end
  end
end