class RemoveProcessor
  include Thymeleaf::Processor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node.attributes.delete('data-th-remove')
    node.children.each do |child|
      node_instruction_child = NodeInstruction.new
      subprocess_node(child, node_instruction_child, node_instruction, statement_factory)
    end
    node.children.clear

    first_child = first_non_empty_children(node_instruction, statement_factory)
    instructions = remove_instructions(statement_factory, attribute, node_instruction.children)
    
    instructions[0].each {|instruction| node_instruction.instructions.especial_instructions.unshift(instruction)}
    instructions[1].each {|instruction| node_instruction.instructions.before_children << instruction}
    instructions[2].each {|instruction| node_instruction.instructions.tag_instructions.unshift(instruction)}
    instructions[3].each {|instruction| node_instruction.instructions.before_children.unshift(instruction)}
    instructions[4].each {|instruction| node_instruction.instructions.attribute_instructions.unshift(instruction)}
    instructions[5].each {|instruction| first_child.instructions.especial_instructions << instruction}  
  end

  private 

  def remove_instructions(statement_factory, attribute, children)
    statements = statement_factory.remove_statement(attribute, children)
    instructions = statements.map {|statement_list| convert_to_instructions(statement_list)}
  end

  def first_non_empty_children(node_instruction, statement_factory)
    node_instruction.children.each do |child|
      return child unless child.first_instruction.squeeze.eql?(statement_factory.newline_statement)
    end
  end
end