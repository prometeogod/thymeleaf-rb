require_relative '../../../precompile/statement_factory'
require_relative '../../../../../lib/thymeleaf'
require_relative '../../../utils/booleanize'
class IfProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node_instruction.instructions.attribute_instructions << if_instruction(statement_factory, attribute)
    node.attributes.delete("data-th-if") 
  end

  private 

  def if_instruction(statement_factory, attribute)
  	if_statement, end_statement = statement_factory.if_statement(attribute)
  	Instruction.new(if_statement, end_statement)
  end
end