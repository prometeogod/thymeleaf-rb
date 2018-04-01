require_relative '../../../../../lib/thymeleaf'
class FragmentProcessor
  include Thymeleaf::Processor  
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    instructions = fragment_instructions(statement_factory, attribute)
    instructions.each{|instruction| node_instruction.instructions.attribute_instructions << instruction}
    node.attributes.delete("data-th-fragment")
  end

  private

  def fragment_instructions(statement_factory, attribute)
    statements = statement_factory.fragment_statement(attribute, DefaultDialect::CONTEXT_FRAGMENT_VAR)
    convert_to_instructions(statements)
  end
end
