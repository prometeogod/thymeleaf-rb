require_relative '../../../../../lib/thymeleaf'
class BlockPreprocessor
  def call(node: nil, buffer_writer: nil, precompiler: nil, attribute: nil, pos: nil, length:nil, object: nil)
    if !node.children.empty?
      precompiler.precompile_children(node.children, buffer_writer)
    end
  end
end