# Class NullPreprocessor
class NullProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    if attribute.nil?
      instructions = null_instructions(statement_factory, node, node_instruction.attributes)
      instructions.each{|instruction| node_instruction.instructions.tag_instructions << instruction}
    else
      node_instruction.attributes.simple_attributes[key] = attribute
    end
  end

  private 

  def null_instructions(statement_factory, node, attributes)
    convert_to_instructions(statement_factory.null_statement(node, attributes))
  end
end
