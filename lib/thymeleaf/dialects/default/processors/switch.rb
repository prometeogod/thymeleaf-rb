require_relative '../../../../../lib/thymeleaf'
class SwitchProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    switch_instructions(statement_factory, attribute).each do |instruction|
      node_instruction.instructions.attribute_instructions << instruction
    end
    node.attributes.delete("data-th-switch")
  end

  private 

  def switch_instructions(statement_factory, attribute)
    switch_statement = statement_factory.switch_statement(attribute, DefaultDialect::CONTEXT_SWITCH_VAR)
    switch_instructions = switch_statement.map {|statement| Instruction.new(statement)}
  end
end