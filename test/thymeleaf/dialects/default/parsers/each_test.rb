require 'thymeleaf/dialects/default/parsers/each'
require 'thymeleaf/context/context_struct'
require 'thymeleaf/context/context_holder'

describe EachExpression do
  def context
    element1 = { name: 'Banana' }
    element2 = { name: 'Apple' }
    element3 = { name: 'Orange' }
    elememt4 = { name: '' }
    iterable = [element1, element2, element3, elememt4]
    ContextHolder.new(ContextStruct.new(products: iterable))
  end

  def render_expression(expression)
    EachExpression.parse(context, expression)
  end

  it 'detects standard usage: iterator : ${iterable}' do
    expression = 'product : ${all_products}'
    result = ['product', nil, 'all_products']
    assert_equal render_expression(expression), result
  end

  it 'detects complete usage: iterator, stat : ${iterable}' do
    expression = 'product, stat : ${all_products}'
    result = %w[product stat all_products]
    assert_equal render_expression(expression), result
  end

  it 'detects simple usage: ${iterable}' do
    expression = '${all_products}'
    result = [nil, nil, 'all_products']
    assert_equal render_expression(expression), result
  end

  it 'detects synamic iterable values: iterator : ${iterable}' do
    expression = 'number : ${[1,2,3,4]}'
    result = ['number', nil, '[1,2,3,4]']
    assert_equal render_expression(expression), result
  end
end
