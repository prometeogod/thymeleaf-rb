class InsertProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node.attributes.delete('data-th-insert')
    node.children.clear
    child = NodeInstruction.new
    node_instruction.add_child(child)
    
    instructions = insert_instructions(statement_factory, attribute)
    instructions[0].each{|instruction| node_instruction.instructions.attribute_instructions << instruction}
    instructions[1].each{|instruction| child.instructions.attribute_instructions << instruction}
    instructions[2].each{|instruction| child.instructions.before_children << instruction}

  end

  private 

  def insert_instructions(statement_factory, attribute)
    statements = statement_factory.insert_statement(attribute, DefaultDialect::CONTEXT_FRAGMENT_VAR)
    instructions = statements.map{|statement_list| convert_to_instructions(statement_list)}
  end
end