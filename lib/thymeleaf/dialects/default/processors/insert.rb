class InsertProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    node.attributes.delete('data-th-insert')
    node.children.clear
    fragment_expresion = Instruction.new("template, fragment = FragmentExpression.parse(context, \'#{attribute}\')")
    
    node_instruction.instructions.attribute_instructions << fragment_expresion
    
    fragment_var = DefaultDialect::CONTEXT_FRAGMENT_VAR
    
    child = NodeInstruction.new
    child.nodetree = node
    node_instruction.add_child(child)
    child.instructions.attribute_instructions << Instruction.new("if (template==\'this\' || template.nil?)",buffer_writer.ending)
    child.instructions.attribute_instructions << Instruction.new("unless fragment.nil?")
    child.instructions.attribute_instructions << Instruction.new("if fragment.match(/#^*/).nil?")
    child.instructions.attribute_instructions << Instruction.new("eval(\'#{fragment_var}_\' + fragment)")
    child.instructions.attribute_instructions << Instruction.new("else")
    # DOM Replacement
    child.instructions.attribute_instructions << Instruction.new("end")
    child.instructions.attribute_instructions << Instruction.new("end")
    child.instructions.attribute_instructions << Instruction.new("else")
    extern_fragment(child)
  end

  def extern_fragment(node_instruction)
  	node_instruction.instructions.before_children << Instruction.new("subtemplate = EvalExpression.parse(context, template)")
    node_instruction.instructions.before_children << Instruction.new("writer.write formatter.print_extern_template(subtemplate, context, fragment)")
    
  end
end