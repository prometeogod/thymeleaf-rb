class DoctypePreprocessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    node_instruction.instructions.especial_instructions << Instruction.new(buffer_writer.doctype_content(node))
  end
end