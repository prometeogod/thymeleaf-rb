require_relative '../../../../../lib/thymeleaf'
class BlockPreprocessor
  include Thymeleaf::Processor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    node.children.each do |child|
      subprocess_node(child, parent_instruction, buffer_writer)
    end
    node.delete
    node_instruction.delete
  end
end