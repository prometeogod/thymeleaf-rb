require_relative '../precompile_dialect'
require_relative '../../../../../lib/thymeleaf'
class FragmentPreprocessor
  include Thymeleaf::Processor  
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    fragment_name = Instruction.new("fragment_name = EvalExpression.parse(context, \'#{attribute}\')")
    fragment_var = PrecompileDialect::CONTEXT_FRAGMENT_VAR
    private_var = Instruction.new("private_var = \"#{fragment_var}_\" + fragment_name")
    method_header = Instruction.new("define_singleton_method(private_var) do ",buffer_writer.ending)
    method_call = Instruction.new(nil,"eval(private_var)")
    
    node_instruction.instructions.attribute_instructions << fragment_name
    node_instruction.instructions.attribute_instructions << private_var
    node_instruction.instructions.attribute_instructions << method_header
    node_instruction.instructions.attribute_instructions << method_call
    
    node.attributes.delete('data-th-fragment')
  end
end
