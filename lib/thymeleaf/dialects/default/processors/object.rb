
require_relative '../../../../../lib/thymeleaf'
class ObjectProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node.attributes.delete('data-th-object')
    
    instructions = object_instructions(statement_factory, attribute)
    instructions.each {|instruction| node_instruction.instructions.attribute_instructions << instruction}
   
  end

  private
  def object_instructions(statement_factory, attribute)
    convert_to_instructions(statement_factory.object_statement(attribute))
  end
  
end