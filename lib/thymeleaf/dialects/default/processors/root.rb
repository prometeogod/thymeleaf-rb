class RootProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node_instruction.instructions.especial_instructions << root_instruction(statement_factory)
  end

  private

  def root_instruction(statement_factory)
  	open_statement, end_statement = statement_factory.root_statement('->(context, writer, formatter)')
  	Instruction.new(open_statement, end_statement)
  end
end