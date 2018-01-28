require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
require_relative '../../../precompiler'
class SwitchPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length: nil, object: nil)
  	BufferWriter.write_node_head(node, buffer)
  	evaluable, expr = Evaluation.evalue(attribute)
  	BufferWriter.write buffer, 'case '+'expresion.call(context,'+'"' +expr+'"' + ')'
  	BufferWriter.write_newline(buffer)
  	if !node.children.empty?
      precompiler = Precompiler.new
      precompiler.precompile_notext_children(node.children, buffer)
    end
    BufferWriter.write buffer, 'end'
    BufferWriter.write_newline(buffer)
    BufferWriter.write_node_tail(node, buffer)
  end
end