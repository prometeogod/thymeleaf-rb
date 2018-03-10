require 'test_helper'
require 'thymeleaf'
describe Thymeleaf::Precompiler do 
  before(:each) do
    @empty_parsed_template = Thymeleaf::Parser.new('').call
    @simple_parsed_template = Thymeleaf::Parser.new('<p></p>').call
    @text_parsed_template = Thymeleaf::Parser.new('<p data-th-text="Texto"></p>').call
    @utext_parsed_template = Thymeleaf::Parser.new('<p data-th-utext="Texto"></p)>').call
    @text_content_template = Thymeleaf::Parser.new('<p>Texto</p>').call
    @if_template = Thymeleaf::Parser.new('<p data-th-if=true>Texto</p>').call
    @unless_template = Thymeleaf::Parser.new('<p data-th-unless=false>Texto</p>').call
    @switch_template = Thymeleaf::Parser.new(template_switch).call
    @default_template = Thymeleaf::Parser.new('<p data-th-class="Texto">Texto</p>').call
    @block_template = Thymeleaf::Parser.new(template_block).call
    @each_template = Thymeleaf::Parser.new('<p data-th-each= "element : ${list}" data-th-text="Texto">Texto</p>').call
    @remove_template = Thymeleaf::Parser.new('<p data-th-remove="none">Texto<h>child</h></p>').call
  end

  it 'should be an empty parsed template' do 
    assert_equal @empty_parsed_template.empty?, true
  end

  it 'should be a function with begin and end tags' do 
    template_function = precompile_function(@simple_parsed_template)
    assert_equal template_function, function_simple_result
  end

  it 'should be a function of text and begin and end tags' do 
    template_function = precompile_function(@text_parsed_template)
    assert_equal template_function, template_text_function
  end

  it 'should be a function of utext and begin and end tags' do 
    template_function = precompile_function(@utext_parsed_template)
    assert_equal template_function, template_utext_function
  end

  it 'should be a function with begin and end tags and text-content' do 
    template_function = precompile_function(@text_content_template)
    assert_equal template_function, template_text_content_function
  end

  it 'should be a function with if begin and end tags and text-content' do 
    template_function = precompile_function(@if_template)
    assert_equal template_function, template_if_function
  end

  it 'should be a function with an unless begin and end tags and text-content' do 
    template_function = precompile_function(@unless_template)
    assert_equal template_function, template_unless_function
  end

  it 'should be a function with a switch var and two if conditionals comparing ' do 
    template_function = precompile_function(@switch_template)
    assert_equal template_function, template_switch_function
  end

  it 'should be a function that process default tags ' do 
    template_function = precompile_function(@default_template)
    assert_equal template_function, template_default_function
  end

  it 'should be a function that process a block tag' do
    template_function = precompile_function(@block_template)
    assert_equal template_function, template_block_function
  end

  it 'should be a function that process a each attribute' do
    template_function = precompile_function(@each_template)
    assert_equal template_function, template_each_function
  end

  it 'should be a function that includes instructions to not process parts of code' do
    template_function = precompile_function(@remove_template)
    assert_equal template_function, template_remove_function
  end 

  private

  def precompile_function(parsed_template)
    Thymeleaf::Precompiler.new(parsed_template).send(:template_function)
  end

  def function_simple_result
   "->(context, writer, formatter){
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write '</p>'
}
"
  end

  def template_text_function
   "->(context, writer, formatter){
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write Oga::XML::Entities.encode(EvalExpression.parse(context,'Texto'))
writer.write '</p>'
}
" 
  end

  def template_utext_function
     "->(context, writer, formatter){
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write EvalExpression.parse(context,'Texto')
writer.write '</p>'
}
" 
  end
  def template_text_content_function
"->(context, writer, formatter){
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write 'Texto'
writer.write '</p>'
}
" 
  end

  def template_if_function
"->(context, writer, formatter){
if booleanize EvalExpression.parse(context, 'true')
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write 'Texto'
writer.write '</p>'
end
}
" 
  end
  
  def template_unless_function
"->(context, writer, formatter){
unless booleanize EvalExpression.parse(context, 'false')
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write 'Texto'
writer.write '</p>'
end
}
" 
  end

  def template_switch 
    '<div data-th-switch="${numero}">
<p data-th-case="1" data-th-text="Texto"></p>
<p data-th-case="2" data-th-text="No"></p>
</div>'
  end 
  
  def template_switch_function
"->(context, writer, formatter){
case_context = ContextHolder.new({}, context)
switch_var = EvalExpression.parse(context, '${numero}')
attributes = {}
writer.write '<div' + formatter.attributes_string(attributes) + '>'
writer.write '
'
if switch_var.eql?(EvalExpression.parse(case_context, '1'))
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write Oga::XML::Entities.encode(EvalExpression.parse(context,'Texto'))
writer.write '</p>'
end
writer.write '
'
if switch_var.eql?(EvalExpression.parse(case_context, '2'))
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write Oga::XML::Entities.encode(EvalExpression.parse(context,'No'))
writer.write '</p>'
end
writer.write '
'
writer.write '</div>'
}
"
  end

  def template_default_function
"->(context, writer, formatter){
attributes = {}
value = EvalExpression.parse(context, 'Texto')
attributes['class'] = value
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write 'Texto'
writer.write '</p>'
}
"
  end
  
  def template_block
'<th-block data-th-class="list list-tag">
  <p data-th-unless="${must_show}" data-th-text="Texto"></p>
</th-block>'
  end

  def template_block_function
  "->(context, writer, formatter){
writer.write '
  '
unless booleanize EvalExpression.parse(context, '${must_show}')
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write Oga::XML::Entities.encode(EvalExpression.parse(context,'Texto'))
writer.write '</p>'
end
writer.write '
'
}
"
  end
  
  def template_each_function
    "->(context, writer, formatter){
def each_method(context, writer, formatter)
variable, stat, enumerable = EachExpression.parse(context, 'element : ${list}')
elements = ContextEvaluator.new(context).evaluate(enumerable)
stat_var = formatter.init_stat_var(stat, elements)
elements.each do |element|
subcontext_vars = {}
subcontext_vars[variable] = element unless variable.nil?
attributes = {\"data-th-text\"=>\"Texto\"}
unless stat.nil?
stat_var[:index]  += 1
stat_var[:count]  += 1
stat_var[:current] = element
stat_var[:even] = stat_var[:count].even?
stat_var[:odd] = stat_var[:count].odd?
stat_var[:first] = (stat_var[:index].eql? 0)
stat_var[:last] = (stat_var[:count].eql? stat_var[:size])
subcontext_vars[stat] = stat_var
end
context = ContextHolder.new(subcontext_vars, context)
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
writer.write Oga::XML::Entities.encode(EvalExpression.parse(context,'Texto'))
writer.write '</p>'
end
end
each_method(context, writer, formatter)
}
"
  end

  def template_remove_function
    "->(context, writer, formatter){
expr = EvalExpression.parse(context, 'none')
unless (expr=='all' || expr == 'true' )
unless (expr =='tag')
attributes = {}
writer.write '<p' + formatter.attributes_string(attributes) + '>'
end
unless (expr == 'body')
writer.write 'Texto'
unless (expr == 'all-but-first')
attributes = {}
writer.write '<h' + formatter.attributes_string(attributes) + '>'
writer.write 'child'
writer.write '</h>'
end
end
unless (expr =='tag')
writer.write '</p>'
end
end
}
"
  end

end
