class CommentProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node_instruction.instructions.especial_instructions << comment_instruction(statement_factory, node)
  end

  private 

  def comment_instruction(statement_factory, node)
    Instruction.new(statement_factory.comment_statement(node))
  end
end