# Processor Each
class EachProcessor
  include Thymeleaf::Processor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
  	node.attributes.delete('data-th-each')
    instructions = each_instructions(statement_factory, attribute, node)
    instructions.each{|instruction| node_instruction.instructions.attribute_instructions << instruction}
  end

  private

  def each_instructions(statement_factory, attribute, node)
    statements = statement_factory.each_statement(attribute, node)
    convert_to_instructions(statements)
  end
end
