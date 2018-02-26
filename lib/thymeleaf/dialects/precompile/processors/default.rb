class DefaultPreprocessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    node.attributes.delete(('data-th-' + key))
    default_instruction_begin = "value = EvalExpression.parse(context, \'#{attribute}\')"
    default_instruction = Instruction.new(default_instruction_begin)
    attributes_instruction = Instruction.new("attributes = #{node.attributes} unless attributes")
    default_attribute_instruction = Instruction.new("attributes[\'#{key}\'] = value")
    delete_attribute = Instruction.new(buffer_writer.delete_attribute_default(key))
    
    node_instruction.instructions.attribute_instructions << default_instruction
    node_instruction.instructions.attribute_instructions << attributes_instruction
    node_instruction.instructions.attribute_instructions << delete_attribute
    node_instruction.instructions.attribute_instructions << default_attribute_instruction
  end
end