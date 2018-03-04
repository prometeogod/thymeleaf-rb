require_relative '../test_helper'
require 'thymeleaf/node_instruction_attributes'
require 'thymeleaf'

describe NodeInstructionAttributes do 
  before(:each) do
    @attributes = NodeInstructionAttributes.new
  end

  it 'should be empty' do
    assert_equal @attributes.empty?, true
  end

  it 'should add something to attributes' do 
    @attributes.simple_attributes['key'] = 'value1'
    assert_equal @attributes.empty?, false
    assert_equal @attributes.simple_attributes, {'key' => 'value1' } 
    @attributes.from_default['key'] = 'value1'
    assert_equal @attributes.from_default, {'key' => 'value1'}
  end
end