
class CaseProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node_instruction.instructions.attribute_instructions << case_instruction(statement_factory, attribute)
    node.attributes.delete("data-th-case")
  end

  private
  
  def case_instruction(statement_factory, attribute)
  	switch_var = DefaultDialect::CONTEXT_SWITCH_VAR
  	case_statement, end_statement = statement_factory.case_statement(attribute, switch_var)
  	Instruction.new(case_statement, end_statement)
  end
end
