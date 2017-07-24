class DefaultProcessorSax
  include Thymeleaf::Processor

  def call(key:nil, node:nil, attribute:nil, context:nil , **_)
    value = EvalExpression.parse(context, attribute)
    node.attributes=node.attributes.clone
    node.attributes.delete(('data-th-'+key))
    node.attributes[key]=value
  end
end