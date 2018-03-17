require_relative '../../../precompile/buffer_writer'
require_relative '../../../../../lib/thymeleaf'
class SwitchProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    new_context = "case_context = ContextHolder.new({}, context)"
    switch_context_instruction = Instruction.new(new_context)
    switch_var = DefaultDialect::CONTEXT_SWITCH_VAR
    begin_instruction_switch = buffer_writer.switch_statement(attribute, switch_var)
    switch_instruction = Instruction.new(begin_instruction_switch)
    node_instruction.instructions.attribute_instructions << switch_context_instruction 
    node_instruction.instructions.attribute_instructions << switch_instruction
    node.attributes.delete("data-th-switch")
  end
end