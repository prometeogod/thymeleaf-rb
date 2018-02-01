require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
require_relative '../../../../../lib/thymeleaf'
require_relative '../precompile_dialect'
class ObjectPreprocessor
  def call(node: nil, buffer: nil, buffer_writer: nil, attribute: nil, pos: nil, length: nil, object: nil)
    evaluable, expr = Evaluation.evalue(attribute)
    context_var = PrecompileDialect::CONTEXT_OBJECT_VAR
    buffer_writer.write "#{context_var} = expresion.call(context,\'#{expr}\')"
    buffer_writer.begin_tag(node) if pos == 1
    if pos == length
      if !node.children.empty?
        precompiler = Thymeleaf::Precompiler.new
        precompiler.precompile_children(node.children, buffer, buffer_writer, context_var)
      end
      buffer_writer.end_tag(node)
    end
  end
end