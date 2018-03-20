require_relative '../../../precompile/buffer_writer'
require_relative '../../../../../lib/thymeleaf'
require_relative '../../../utils/booleanize'
class IfProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    begin_instruction = buffer_writer.if_statement(attribute)
    end_instruction = buffer_writer.ending
    node_instruction.instructions.attribute_instructions << Instruction.new(begin_instruction, end_instruction)
    node.attributes.delete("data-th-if") 
  end
end