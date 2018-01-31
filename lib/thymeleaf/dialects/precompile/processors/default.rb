class DefaultPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length: nil, object: nil)
  	if pos == 1
  	  BufferWriter.begin_tag(buffer, node)
  	  BufferWriter.write buffer, 'begin'
    end
    if pos == length
      if !node.children.empty?
        precompiler = Thymeleaf::Precompiler.new
        precompiler.precompile_children(node.children, buffer)
      end
      BufferWriter.end_tag(buffer, node)
      BufferWriter.write buffer, 'end'
    end
  end
end