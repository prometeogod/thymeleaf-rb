# Class NullPreprocessor
class NullPreprocessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
  	if attribute.nil?
      if node.children.empty? && node_instruction.children.nil?
        begin_instruction = buffer_writer.pretty_tag(node)
        instruction = Instruction.new(begin_instruction)
      else
      	begin_instruction = buffer_writer.begin_tag(node)
        end_instruction = buffer_writer.end_tag(node)
        instruction = Instruction.new(begin_instruction,end_instruction)
      end
      string_attributes_instruction = Instruction.new("attributes = #{node.attributes} unless attributes")
      node_instruction.instructions.tag_instructions << string_attributes_instruction
      node_instruction.instructions.tag_instructions << instruction
    end
  end
end
