require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
require_relative '../../../../../lib/thymeleaf'
class UnlessPreprocessor
  def call(node: nil, buffer: nil, buffer_writer: nil, precompiler: nil, attribute: nil, pos: nil, length: nil, object: nil)
    #evaluable, expr = Evaluation.evalue(attribute)
    buffer_writer.write "unless booleanize EvalExpression.parse(ContextHolder.new(context),\'#{attribute}\')"
    buffer_writer.begin_tag(node) if pos == 1
    if pos == length
      if !node.children.empty?
        precompiler.precompile_children(node.children, buffer, buffer_writer)
      end
      buffer_writer.end_tag(node)
      buffer_writer.ending
    end
  end
end