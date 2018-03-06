# Class NullPreprocessor
class NullPreprocessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
  	if attribute.nil?
      simple_attributes_instruction = Instruction.new("attributes = #{node_instruction.attributes.simple_attributes}")
      if node.children.empty? && node_instruction.children.empty?
        instruction = Instruction.new(buffer_writer.pretty_tag(node))
      else
        instruction = Instruction.new(buffer_writer.begin_tag(node),buffer_writer.end_tag(node))
      end
      node_instruction.instructions.tag_instructions << simple_attributes_instruction
      node_instruction.attributes.from_default.each do |key, value|
        attribute_value = Instruction.new("value = #{value}")
        node_instruction.instructions.tag_instructions << attribute_value
        attribute_set = Instruction.new("attributes[\'#{key}\'] = value")
        node_instruction.instructions.tag_instructions << attribute_set
      end
      node_instruction.instructions.tag_instructions << instruction
    else
      node_instruction.attributes.simple_attributes[key] = attribute
    end

  end
end
