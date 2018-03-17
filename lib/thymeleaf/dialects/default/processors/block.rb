require_relative '../../../../../lib/thymeleaf'
require_relative '../../../../../lib/thymeleaf/processor'
class BlockProcessor
  include Thymeleaf::Processor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    node.children.each do |child|
      node_instruction_child = NodeInstruction.new
      node_instruction_child.nodetree = child
      subprocess_node(child, node_instruction_child, parent_instruction, buffer_writer)
    end
    node.delete
    node_instruction.delete
  end
end