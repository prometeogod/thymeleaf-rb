require_relative '../test_helper'
require 'thymeleaf/instructions'

describe Instructions do
  before(:each) do
    @instructions = Instructions.new
    @tag_instructions = [Instruction.new(3,4)]
    @attribute_instructions = [Instruction.new(2,5)]
    @especial_instructions = [Instruction.new(1,6)]
    @before_children_instructions = [Instruction.new(3.5,3.75)]
    @buffer = []
  end

  it 'should create an empty instructions object' do 
    assert_equal @instructions.class, Instructions
    assert_equal @instructions.empty?, true
  end 
  
  it 'should write especial_instructions in buffer' do 
    @instructions.especial_instructions = @especial_instructions
    assert_equal @instructions.especial_instructions, @especial_instructions
    @instructions.to_buffer_begin(@buffer)
    assert_equal @buffer, [1]
    @instructions.to_buffer_end(@buffer)
    assert_equal @buffer, [1,6]
  end  

  it 'should write tag_instructions in buffer' do 
    @instructions.tag_instructions = @tag_instructions
    assert_equal @instructions.tag_instructions, @tag_instructions
    @instructions.to_buffer_begin(@buffer)
    assert_equal @buffer, [3]
    @instructions.to_buffer_end(@buffer)
    assert_equal @buffer, [3,4]
  end  
  
  it 'should write attribute_instructions in buffer' do
    @instructions.attribute_instructions = @attribute_instructions
    assert_equal @instructions.attribute_instructions, @attribute_instructions
    @instructions.to_buffer_begin(@buffer)
    assert_equal @buffer, [2]
    @instructions.to_buffer_end(@buffer)
    assert_equal @buffer, [2,5]
  end

  it 'should write instructions in buffer' do 
    @instructions.attribute_instructions = @attribute_instructions
    @instructions.tag_instructions = @tag_instructions
    @instructions.especial_instructions = @especial_instructions
    @instructions.to_buffer_begin(@buffer)
    @instructions.to_buffer_end(@buffer)
    assert_equal @buffer, [1,2,3,4,5,6]
  end

  it 'should write before children instructions ' do 
    @instructions.attribute_instructions = @attribute_instructions
    @instructions.tag_instructions = @tag_instructions
    @instructions.especial_instructions = @especial_instructions
    @instructions.before_children = @before_children_instructions
    @instructions.to_buffer_begin(@buffer)
    @instructions.to_buffer_before_children(@buffer)
    @instructions.to_buffer_end(@buffer)
    assert_equal @buffer, [1,2,3,3.5,3.75,4,5,6]
  end     
end
