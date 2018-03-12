class RemovePreprocessor
  include Thymeleaf::Processor

  REMOVE_ALL           = 'all'.freeze
  REMOVE_BODY          = 'body'.freeze
  REMOVE_TAG           = 'tag'.freeze
  REMOVE_ALL_BUT_FIRST = 'all-but-first'.freeze
  REMOVE_NONE          = 'none'.freeze
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    node.attributes.delete('data-th-remove')
    node.children.each do |child|
      node_instruction_child = NodeInstruction.new
      node_instruction_child.nodetree = child
      subprocess_node(child, node_instruction_child, node_instruction, buffer_writer)
    end
    node.children.clear
    
    remove_expresion = Instruction.new("expr = EvalExpression.parse(context, \'#{attribute}\')")
    remove_all_conditional = Instruction.new("unless (expr==\'#{REMOVE_ALL}\' || expr == \'true\' )",buffer_writer.ending)
    remove_tag_conditional= "unless (expr ==\'#{REMOVE_TAG}\')"
    
    node_instruction.instructions.especial_instructions.unshift(remove_all_conditional)
    node_instruction.instructions.especial_instructions.unshift(remove_expresion)

    node_instruction.instructions.before_children << Instruction.new("unless (expr == \'#{REMOVE_BODY}\')")
    node_instruction.instructions.tag_instructions.unshift(Instruction.new(nil,remove_tag_conditional))
    node_instruction.instructions.tag_instructions.unshift(Instruction.new(nil,buffer_writer.ending))

    node_instruction.instructions.tag_instructions.unshift(Instruction.new(remove_tag_conditional))
    node_instruction.instructions.before_children.unshift(Instruction.new(buffer_writer.ending))

    
    node_instruction.instructions.attribute_instructions.unshift(Instruction.new(nil,buffer_writer.ending))
    
    unless node_instruction.children.empty?
      node_instruction.instructions.tag_instructions.unshift(Instruction.new(nil,buffer_writer.ending))	
      first_child = node_instruction.children.first 
      first_child.instructions.especial_instructions << Instruction.new(nil,"unless (expr == \'#{REMOVE_ALL_BUT_FIRST}\')")
    end  
  end
end