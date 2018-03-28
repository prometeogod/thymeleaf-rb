class MetaProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    meta_instructions(statement_factory, node).each {|instruction| node_instruction.instructions.especial_instructions << instruction}
  end

  private

  def meta_instructions(statement_factory, node)
    convert_to_instructions(statement_factory.meta_statement(node))
  end
end