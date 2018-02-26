require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
require_relative '../../../../../lib/thymeleaf'
require_relative '../precompile_dialect'
class ObjectPreprocessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    node.attributes.delete('data-th-object')
    object_var = "obj_var = EvalExpression.parse_single_expression(context, \'#{attribute}\')"
    context_holder = "context = ContextHolder.new({}, obj_var)"
   
    begin_end_block = Instruction.new(buffer_writer.begining, buffer_writer.ending)
    object_var_instruction = Instruction.new(object_var)
    node_instruction.instructions.attribute_instructions << object_var_instruction
    node_instruction.instructions.attribute_instructions << begin_end_block
    node_instruction.instructions.attribute_instructions << Instruction.new(context_holder)
  end
end