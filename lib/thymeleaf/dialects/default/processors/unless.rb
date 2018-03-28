require_relative '../../../../../lib/thymeleaf'
class UnlessProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node_instruction.instructions.attribute_instructions << unless_instruction(statement_factory, attribute)
    node.attributes.delete("data-th-unless") 
  end

  private 

  def unless_instruction(statement_factory, attribute)
    unless_statement,end_statement = statement_factory.unless_statement(attribute)
    Instruction.new(unless_statement, end_statement)
  end
end