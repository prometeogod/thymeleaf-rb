# SwitchProcessor class definition : it process switch tag
class SwitchProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, **_)
    condition = EvalExpression.parse(context, attribute)
    new_context = ContextHolder.new({}, context)
    new_context.set_private DefaultDialect::CONTEXT_SWITCH_VAR, condition
  
    node.attributes.delete('data-th-switch')
    new_context
  end

  def subcontext?
    true
  end
end
