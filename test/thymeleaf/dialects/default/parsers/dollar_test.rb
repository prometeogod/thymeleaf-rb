require 'thymeleaf/dialects/default/parsers/dollar'
require 'thymeleaf/context/context_struct'
require 'thymeleaf/context/context_holder'

describe DollarExpression do
  def context
    user_content = { name: 'John', surname: 'Color' }
    ContextHolder.new(ContextStruct.new(user: user_content))
  end

  def render_expression(expression)
    DollarExpression.parse(context, expression).to_s
  end

  it 'detects dollar syntax with context' do
    assert_equal render_expression('${user.name}'), 'John'
    assert_equal render_expression('${user.surname}'), 'Color'
  end

  it 'evaluates ruby expressions' do
    expression = 'The result is: ${5 * 4 + 3}'
    result = 'The result is: 23'
    assert_equal render_expression(expression), result
  end

  it 'detects dollar syntax in substring' do
    assert_equal render_expression('Hello, ${user.name}'), 'Hello, John'
  end

  it 'returns empty string on fail' do
    assert_empty render_expression('${user.inexistent}')
    assert_equal render_expression('Dear ${user.inexistent}'), 'Dear '
  end

  it 'works even with escaped character' do
    assert_equal render_expression('Hi, \${user.name}'), 'Hi, \\John'
  end
end
