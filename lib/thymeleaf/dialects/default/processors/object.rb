require_relative '../../../utils/booleanize'

class ObjectProcessor

  include Thymeleaf::Processor

  def call(node:nil,attribute:nil, context:nil, **_)
    node.attributes.delete('data-th-object')

    obj_var = EvalExpression.parse_single_expression(context, attribute)
    new_context = ContextHolder.new({},context)
    new_context.set_private(DefaultDialect::CONTEXT_OBJECT_VAR,obj_var)

    new_context
  end

  def has_subcontext?
    true
  end
end