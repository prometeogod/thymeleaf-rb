class TextContentProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node_instruction.instructions.especial_instructions << text_content_instruction(statement_factory, node)
  end

  private

  def text_content_instruction(statement_factory, node)
    Instruction.new(statement_factory.text_content(node))
  end
end