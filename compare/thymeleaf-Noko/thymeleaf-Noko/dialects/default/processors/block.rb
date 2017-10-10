module ThymeleafNoko
class BlockProcessor

  include ThymeleafNoko::Processor
  
  def call(node:nil, context:nil, **_)
    node.children.reverse.each do |child|
      subprocess_node(context, child)
      node.add_next_sibling child
    end
    node.unlink
  end
end
end