require 'test_helper'
require 'thymeleaf/context/context_holder'
require 'thymeleaf/context/context_struct'
describe ContextHolder do
  before(:each) do
    context = {'key' => 'value',
    			'array'=>[0,1]}
    context_struct =  ContextStruct.new(context)
    @context_holder = ContextHolder.new(context)
    context1 = {key: 'value',
    			array: [1,[2],context_struct]
               }
    @context_holder1 = ContextHolder.new(context1,@context_holder)

  end

  it 'should return parent_context root if root it is not nil' do
    assert_equal @context_holder1.root, @context_holder.root
  end
end
