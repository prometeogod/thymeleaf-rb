module ThymeleafNoko
class TextProcessor
  include ThymeleafNoko::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    node.content = EvalExpression.parse(context, attribute.value)
    attribute.unlink
  end
end
end