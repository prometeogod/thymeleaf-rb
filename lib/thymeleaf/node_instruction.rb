require_relative 'instruction'
class NodeInstruction
  
  attr_accessor :instructions, :nodetree, :children, :parent

  def initialize(instructions = Instructions.new, nodetree = nil, children = nil, parent = nil)
   	@instructions = instructions
    @nodetree = nodetree
    @children = children 
    @parent = parent
  end

  def empty?
    return true if instructions.empty?
    false
  end

  def to_buffer(buffer)
    instructions.to_buffer_begin(buffer)
    # Other instructions
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