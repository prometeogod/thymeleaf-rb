require_relative '../../../precompile/buffer_writer'
require_relative '../../../../../lib/thymeleaf'
class ObjectProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    node.attributes.delete('data-th-object')
    object_var = "obj_var = EvalExpression.parse_single_expression(context, \'#{attribute}\')"
    context_holder = "context = ContextHolder.new({}, obj_var)"
   
    
    object_var_instruction = Instruction.new(object_var)
    node_instruction.instructions.attribute_instructions << Instruction.new("def object_method(context, writer, formatter)", buffer_writer.ending)
    node_instruction.instructions.attribute_instructions << object_var_instruction
    node_instruction.instructions.attribute_instructions << Instruction.new(context_holder,"object_method(context, writer, formatter)")
  end
end