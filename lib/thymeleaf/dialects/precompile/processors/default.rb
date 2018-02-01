class DefaultPreprocessor
  def call(node: nil, buffer: nil, buffer_writer: nil, attribute: nil, pos: nil, length: nil, object: nil)
  	if pos == 1
  	  buffer_writer.begin_tag(node)
  	  buffer_writer.begining
    end
    if pos == length
      if !node.children.empty?
        precompiler = Thymeleaf::Precompiler.new
        precompiler.precompile_children(node.children, buffer, buffer_writer)
      end
      buffer_writer.end_tag(node)
      buffer_writer.ending
    end
  end
end