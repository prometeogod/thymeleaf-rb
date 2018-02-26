require_relative '../test_helper'
require 'thymeleaf/instruction'

describe Instruction do
  before(:each) do
    @instruction = Instruction.new('example')
  end

  it 'should create an instruction object' do 
    assert_equal @instruction.class, Instruction
  end

  it 'should create an instruction with begin and end instruction' do 
    example = Instruction.new('begin','end')
    assert_equal example.begin_instruction, 'begin'
    assert_equal example.end_instruction, 'end'
  end
  
  it 'should return true if instruction empty false otherwise' do 
    example = Instruction.new 
    assert_equal example.empty?, true
    example2 = Instruction.new('begin')
    assert_equal example2.empty?, false
  end 
  
  it 'should return an String of all the components of instruction joined' do 
    example = Instruction.new('Hello','Good morning')
    assert_equal example.join(' ') , 'Hello Good morning'
  end
   
end