require_relative 'instruction'
require_relative 'instructions'
require_relative 'node_instruction_attributes'
class NodeInstruction
  
  attr_accessor :instructions, :nodetree, :children, :parent, :attributes

  def initialize(instructions = Instructions.new, nodetree = nil, children = nil, parent = nil, attributes = NodeInstructionAttributes.new)
   	@instructions = instructions
    @nodetree = nodetree
    @children = children 
    @parent = parent
    @attributes = attributes
  end

  def empty?
    return true if instructions.empty?
    false
  end

  def to_buffer(buffer)
    instructions.to_buffer_begin(buffer)
    unless children.nil?
      children.each do |child|
        child.to_buffer(buffer)
      end
    end
    instructions.to_buffer_end(buffer) 
  end

  def add_child(child)
    child.parent = self
    self.children = [] if children.nil?
    children << child
  end

  def delete
    parent = self.parent
    parent.children.delete(self)
  end 
  
end