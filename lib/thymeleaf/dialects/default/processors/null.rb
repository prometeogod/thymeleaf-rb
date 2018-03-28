# Class NullPreprocessor
class NullProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
  	if attribute.nil?
      unless node.name.empty?
        simple_attributes_instruction = Instruction.new("attributes = #{node_instruction.attributes.simple_attributes}")
        instruction = Instruction.new(statement_factory.begin_tag(node),statement_factory.end_tag(node))
        node_instruction.instructions.tag_instructions << simple_attributes_instruction
        node_instruction.attributes.from_default.each do |key, value|
          attribute_value = Instruction.new("value = #{value}")
          node_instruction.instructions.tag_instructions << attribute_value
          attribute_set = Instruction.new("attributes[\'#{key}\'] = value")
          node_instruction.instructions.tag_instructions << attribute_set
        end
      node_instruction.instructions.tag_instructions << instruction
      end
    else
      node_instruction.attributes.simple_attributes[key] = attribute
    end

  end
end
