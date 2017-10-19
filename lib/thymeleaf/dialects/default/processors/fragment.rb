# FragmentProcessor class definition
class FragmentProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, **_)
    fragment_name = EvalExpression.parse(context, attribute)
    private_var = DefaultDialect.context_fragment_var(fragment_name)
    context.root.set_private private_var, node

    node.attributes.delete('data-th-fragment')
  end
end
