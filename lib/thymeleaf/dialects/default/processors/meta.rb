class MetaPreprocessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    instructions = node_instruction.instructions.especial_instructions
    instructions << Instruction.new("attributes = #{node.attributes}")
    instructions << Instruction.new(buffer_writer.meta_content(node))
  end
end