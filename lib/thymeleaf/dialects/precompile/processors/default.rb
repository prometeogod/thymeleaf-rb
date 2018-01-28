class DefaultPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length: nil, object: nil)
  	if pos == 1
  	  BufferWriter.write_node_head(node, buffer)
  	  BufferWriter.write_newline(buffer)
  	  BufferWriter.write buffer, 'begin'
  	  BufferWriter.write_newline(buffer)
    end
    if pos == length
      if !node.children.empty?
        precompiler = Precompiler.new
        precompiler.precompile_children(node.children, buffer)
      end
      BufferWriter.write_node_tail(node, buffer)
      BufferWriter.write buffer, 'end'
      BufferWriter.write_newline(buffer)
    end
  end
end