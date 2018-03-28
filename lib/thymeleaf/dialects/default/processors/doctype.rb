class DoctypeProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node_instruction.instructions.especial_instructions << doctype_instruction(statement_factory, node)
  end

  private

  def doctype_instruction(statement_factory, node)
     Instruction.new(statement_factory.doctype_statement(node))
  end
end