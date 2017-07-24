require_relative '../../../nodetree'

class BlockProcessorSax
  include Thymeleaf::Processor

  def call(node:nil, context:nil, list:nil, **_)
    node.children.reverse.each do |child|
      subprocess_node(context, child, list)
      node.add_next_sibling(child)
    end
    list.delete(node)
  end
end