require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
require_relative '../../../precompiler'
class IfPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length:nil, object: nil)
    evaluable, expr = Evaluation.evalue(attribute)
    BufferWriter.write buffer, 'if ' + ' booleanize '+ 'expresion.call(context,'+'"' +expr+'"' + ').to_s'
    BufferWriter.write_newline(buffer)
    BufferWriter.write_node_head(node, buffer) if pos == 1
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