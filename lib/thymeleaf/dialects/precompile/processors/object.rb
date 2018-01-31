require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
require_relative '../../../../../lib/thymeleaf'
require_relative '../precompile_dialect'
class ObjectPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length: nil, object: nil)
    evaluable, expr = Evaluation.evalue(attribute)
    context_var = PrecompileDialect::CONTEXT_OBJECT_VAR
    BufferWriter.write buffer, context_var + ' = '+ 'expresion.call(context,'+'"' +expr+'"' + ')'
    BufferWriter.begin_tag(buffer, node) if pos == 1
    if pos == length
      if !node.children.empty?
        precompiler = Thymeleaf::Precompiler.new
        precompiler.precompile_children(node.children, buffer, context_var)
      end
      BufferWriter.end_tag(buffer, node)
    end
  end
end