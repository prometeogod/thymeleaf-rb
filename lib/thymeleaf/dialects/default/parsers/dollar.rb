# DollarExpression class definition
class DollarExpression
  def self.parse(context, expr, mode = nil, **_args)
    expr.gsub(/(\${.+?})/) do |match|
      conv = ContextEvaluator.new(context).evaluate(match[2..-2])
      return conv if mode.eql? :single_expression
      conv
    end
  end
end
