require_relative '../../../precompile/buffer_writer'
class CasePreprocessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    switch_var = PrecompileDialect::CONTEXT_SWITCH_VAR
    case_instruction_begin = buffer_writer.case_statement(attribute, switch_var)
    case_instruction_end = buffer_writer.ending
    case_instruction = Instruction.new(case_instruction_begin, case_instruction_end)
    node_instruction.instructions.attribute_instructions << case_instruction
    node.attributes.delete("data-th-case")
  end
end