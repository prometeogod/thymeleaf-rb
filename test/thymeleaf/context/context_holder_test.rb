require 'test_helper'
require 'thymeleaf/context/context_holder'
require 'thymeleaf/context/context_struct'
describe ContextHolder do
  before(:each) do
    context = {'key' => 'value',
    			'array'=>[0,1]}
    context_struct =  ContextStruct.new(context)
    @context_holder = ContextHolder.new(context)
    @result = '{key:value,[0,1]}'
    context1 = {key: 'value',
    			array: [1,[2],context_struct]
               }
    @context_holder1 = ContextHolder.new(context1,@context_holder)
    @result1 = '{key:value,[1,[2],{key:value,array:[0,1]}]}'

  end
  it 'should return a string from a context_holder' do
    context_string = @context_holder.to_s
    assert_equal context_string, @result
    context_string1 = @context_holder1.to_s
    assert_equal context_string1, @result1
  end

  it 'should return parent_context root if root it is not nil' do
    assert_equal @context_holder1.root, @context_holder.root
  end
end
