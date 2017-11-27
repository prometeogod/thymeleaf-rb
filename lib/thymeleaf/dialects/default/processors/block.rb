require_relative '../../../nodetree'
# BlockProcessor class definition
class BlockProcessor
  include Thymeleaf::Processor
  def call(node: nil, context: nil, list: nil, buffer: nil,  **_)
  	node.mark
  	node.mark_decendents
  	node.delete_tail
  	node.delete_tail_decendents
    node.children.reverse.each do |child|
      subprocess_node(context, child, list)
      node.add_next_sibling(child)
    end
    write_buffer(node, buffer)
    list.delete(node)
  end

  private
  
  def write_buffer(node, buffer)
  	node.children.each do |child|
      NodeWriter.write_buffer(buffer, child.to_html)
  	end
  end
end
