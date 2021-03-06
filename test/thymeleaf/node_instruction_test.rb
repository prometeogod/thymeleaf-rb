require_relative '../test_helper'
require 'thymeleaf/node_instruction'
require 'thymeleaf'

describe NodeInstruction do 
  before(:each) do
    @node = NodeInstruction.new
    @nodetree = NodeTree.new('example_nodetree')
    @buffer = []
  end

  it 'should create a node with an empty instruction' do
    node = NodeInstruction.new
    assert_equal node.empty?, true
  end

  it 'should create a node with an instruction' do 
    node = NodeInstruction.new(Instruction.new("example"))
    assert_equal node.empty?, false
    assert_equal node.instructions.join, "example"
  end

  it 'should create a node with a instruction and a nodetree' do
    node = NodeInstruction.new("example", @nodetree)
    assert_equal node.instructions, "example"
    assert_equal @nodetree, node.nodetree
  end

  it 'should not have children' do 
    node = NodeInstruction.new(Instruction.new("example"),@nodetree)
    assert_equal node.children, []
  end  

  it 'should have next node' do 
  	node_next = NodeInstruction.new(Instruction.new([1,2]))
    node = NodeInstruction.new(Instruction.new('example'), @nodetree,[node_next])
    assert_equal node.children , [node_next]
  end

  it 'should have a parent' do
    node_next = NodeInstruction.new(Instruction.new('next'))
    node = NodeInstruction.new(Instruction.new('example'), @nodetree, node_next, @nodetree)
    assert_equal node.parent, @nodetree
  end

  it 'should add a child ' do 
    node = NodeInstruction.new(Instruction.new('inst1'))
    child = NodeInstruction.new(Instruction.new('inst2'))
    node.add_child(child)
    assert_equal child.parent, node
    assert_equal node.children[0], child
  end

  it 'should add several children' do
    node = NodeInstruction.new(Instruction.new('inst1'))
    child1 = NodeInstruction.new(Instruction.new('inst2'))
    child2 = NodeInstruction.new(Instruction.new('inst3'))
    child3 = NodeInstruction.new(Instruction.new('inst4'))
    node.add_child(child1)
    node.add_child(child2)
    node.add_child(child3)
    assert_equal node.children.length, 3
    assert_equal node.children, [child1,child2,child3]
  end

  it 'should delete a node instruction from parent' do 
    child = NodeInstruction.new
    @node.add_child(child)
    assert_equal @node.children.include?(child), true
    child.delete
    assert_equal @node.children.include?(child), false
  end

  it 'should create a node instruction and add attributes' do
    attributes = {'something' => 1 }
    node = NodeInstruction.new(Instruction.new('inst1'))
    assert_equal node.attributes.empty?, true
    node.attributes.simple_attributes['something'] = 1
    assert_equal node.attributes.simple_attributes, attributes
  end

  it 'should run the instructions in the rigth order' do
    @node.instructions.especial_instructions << Instruction.new(1,8)
    @node.instructions.attribute_instructions << Instruction.new(2,7)
    @node.instructions.tag_instructions << Instruction.new(3,6)
    @node.instructions.before_children << Instruction.new(4,5)
    @node.to_buffer(@buffer)
    assert_equal @buffer, [1,2,3,4,5,6,7,8]
  end

  it 'should return the first intruction of the node' do 
    @node.instructions.especial_instructions << Instruction.new('primera')
    assert_equal @node.first_instruction, 'primera'
    @node.instructions.especial_instructions << Instruction.new('segunda')
    assert_equal @node.first_instruction, 'primera'
  end

end