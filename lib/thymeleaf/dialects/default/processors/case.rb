class CaseProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, list:nil, **_)
    node.attributes.delete('data-th-case')

    var_cmp = EvalExpression.parse(context,attribute)

    unless case_equals? context, var_cmp
      node.children.each{ |child| node.children.delete(child)}
      list.delete(node)
    end
  end
  
  def case_equals?(context, var_comparation)
    (context.has_private DefaultDialect::CONTEXT_SWITCH_VAR) &&
        (context.get_private DefaultDialect::CONTEXT_SWITCH_VAR).eql?(var_comparation)
  end
  
  
end