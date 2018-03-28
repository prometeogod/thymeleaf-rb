# UTextProcessor
class UTextProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)   
    text_node = NodeInstruction.new
    text_node.instructions.especial_instructions << utext_instruction(statement_factory, attribute)
    node_instruction.add_child(text_node)
    node.children.clear
    node.attributes.delete('data-th-utext')
  end

  private

  def utext_instruction(statement_factory, attribute)
    Instruction.new(statement_factory.utext_statement(attribute))
  end
end