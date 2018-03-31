require_relative 'instruction'
require_relative 'instructions'
require_relative 'node_instruction_attributes'
class NodeInstruction
  
  attr_accessor :instructions, :nodetree, :children, :parent, :attributes

  def initialize(instructions = Instructions.new, nodetree = nil, children = [], parent = nil, attributes = NodeInstructionAttributes.new)
   	@instructions = instructions
    @nodetree = nodetree
    @children = children 
    @parent = parent
    @attributes = attributes
  end

  def empty?
    instructions.empty?
  end

  def first_instruction
    instructions.first_instruction.to_a[0]
  end

  def to_buffer(buffer)
    instructions.to_buffer_begin(buffer)
    instructions.to_buffer_before_children(buffer)
    unless children.nil?
      children.each do |child|
        child.to_buffer(buffer)
      end
    end
    instructions.to_buffer_end(buffer) 
  end

  def add_child(child)
    unless children.include?(child)
      child.parent = self
      children << child
    end
  end

  def delete
    parent = self.parent
    parent.children.delete(self)
  end 
  
end