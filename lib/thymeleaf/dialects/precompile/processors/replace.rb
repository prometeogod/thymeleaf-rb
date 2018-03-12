class ReplacePreprocessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    node.attributes.delete('data-th-insert')
    node.children.clear
    node.attributes.clear
    fragment_expresion = Instruction.new("template, fragment = FragmentExpression.parse(context, \'#{attribute}\')")
    node_instruction.nodetree = node
    node.name = ''
    
    node_instruction.instructions.tag_instructions.clear
    node_instruction.instructions.especial_instructions.clear
    node_instruction.instructions.attribute_instructions.clear

    node_instruction.instructions.attribute_instructions << fragment_expresion
    
    fragment_var = PrecompileDialect::CONTEXT_FRAGMENT_VAR
    
  
    
    node_instruction.instructions.attribute_instructions << Instruction.new("if (template==\'this\' || template.nil?)",buffer_writer.ending)
    node_instruction.instructions.attribute_instructions << Instruction.new("unless fragment.nil?")
    node_instruction.instructions.attribute_instructions << Instruction.new("if fragment.match(/#^*/).nil?")
    node_instruction.instructions.attribute_instructions << Instruction.new("eval(\'#{fragment_var}_\' + fragment)")
    node_instruction.instructions.attribute_instructions << Instruction.new("else")
    # DOM Replacement
    node_instruction.instructions.attribute_instructions << Instruction.new("end")
    node_instruction.instructions.attribute_instructions << Instruction.new("end")
    node_instruction.instructions.attribute_instructions << Instruction.new("else")

    extern_fragment(node_instruction)
    
  end

  def extern_fragment(node_instruction)
  	node_instruction.instructions.before_children << Instruction.new("subtemplate = EvalExpression.parse(context, template)")
    node_instruction.instructions.before_children << Instruction.new("writer.write formatter.print_extern_template(subtemplate, context, fragment)")
    
  end
end