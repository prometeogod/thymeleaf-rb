module ThymeleafNoko
class UTextProcessor
  include ThymeleafNoko::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    node.inner_html = EvalExpression.parse(context, attribute.value)
    attribute.unlink
  end
end
end