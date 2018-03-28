require_relative '../../../utils/statement_to_instruction_converter'
class ReplaceProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node.attributes.delete('data-th-insert')
    node.children.clear
    node.attributes.clear
    node.name = ''
    
    node_instruction.instructions.tag_instructions.clear
    node_instruction.instructions.especial_instructions.clear
    node_instruction.instructions.attribute_instructions.clear

    attribute_instructions, before_children = replace_instructions(statement_factory, attribute)
    attribute_instructions.each {|instruction| node_instruction.instructions.attribute_instructions << instruction}
    before_children.each {|instruction| node_instruction.instructions.before_children << instruction}
    
  end

  private 
  
  def replace_instructions(statement_factory, attribute)
    fragment_var = DefaultDialect::CONTEXT_FRAGMENT_VAR
    attribute_statements, before_children = statement_factory.replace_statement(attribute, fragment_var)
    [attribute_instructions(attribute_statements) ,before_children_instructions(before_children)]
  end

  def attribute_instructions(statement_list)
    convert_to_instructions(statement_list)
  end

  def before_children_instructions(statement_list)
    convert_to_instructions(statement_list)
  end
end
