require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
require_relative '../../../precompiler'
require_relative '../precompile_dialect'
class ObjectPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length: nil, object: nil)
    evaluable, expr = Evaluation.evalue(attribute)
    context_var = PrecompileDialect::CONTEXT_OBJECT_VAR
    BufferWriter.write buffer, context_var + ' = '+ 'expresion.call(context,'+'"' +expr+'"' + ')'
    BufferWriter.write_newline(buffer)
    BufferWriter.write_node_head(node, buffer) if pos == 1
    if pos == length
      if !node.children.empty?
        precompiler = Precompiler.new
        precompiler.precompile_children(node.children, buffer, context_var)
      end
      BufferWriter.write_node_tail(node, buffer)
    end
  end
end