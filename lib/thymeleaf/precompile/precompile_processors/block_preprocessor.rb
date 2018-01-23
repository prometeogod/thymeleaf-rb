require_relative '../precompiler'
class BlockPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length:nil, object: nil)
    if !node.children.empty?
      precompiler = Precompiler.new
      precompiler.precompile_children(node.children, buffer)
    end
  end
end