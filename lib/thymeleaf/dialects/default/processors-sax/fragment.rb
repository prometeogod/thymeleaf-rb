class FragmentProcessorSax
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    
    fragment_name = EvalExpression.parse(context, attribute)

    context.root.set_private DefaultDialectSax::context_fragment_var(fragment_name), node

    node.attributes.delete('data-th-fragment')
  end

end