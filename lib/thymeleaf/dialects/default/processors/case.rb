# CaseProcessor class definition : it process case tags
class CaseProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, list: nil, **_)
    node.attributes.delete('data-th-case')

    var_cmp = EvalExpression.parse(context, attribute)

    return if case_equals? context, var_cmp
    node.children.clear
    list.delete(node)
  end

  def case_equals?(context, var_comparation)
    context_switch_var = DefaultDialect::CONTEXT_SWITCH_VAR
    (context.private? context_switch_var) &&
      (context.get_private context_switch_var).eql?(var_comparation)
  end
end
