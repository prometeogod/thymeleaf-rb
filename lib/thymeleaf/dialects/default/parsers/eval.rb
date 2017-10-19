require_relative 'selection'
require_relative 'dollar'
# EvalExpression class definition
class EvalExpression
  def self.parse(context, expr, mode = nil, **_)
    context_object_var = context.get_private(DefaultDialect::CONTEXT_OBJECT_VAR)
    text = SelectionExpression.parse(context, expr, context_object_var)
    DollarExpression.parse(context, text, mode)
  end

  def self.parse_single_expression(context, expr, **_)
    parse(context, expr, :single_expression)
  end
end
