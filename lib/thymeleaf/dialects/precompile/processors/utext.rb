require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
# UTextProcessor
class UTextPreprocessor
  def call(node: nil, buffer_writer: nil, precompiler: nil, attribute: nil, pos: nil, length: nil, object: nil)
    buffer_writer.begin_tag(node) if pos == 1
    evaluable, expr = Evaluation.evalue(attribute)
    #buffer_writer.write "writer.write EvalExpression.parse(context,\'#{attribute}\')"
    if evaluable
      buffer_writer.write "writer.write expresion.call(context,\'#{expr}\').to_s"
    else
      buffer_writer.write "writer.write \'#{expr}\'"
    end
    if pos == length
      buffer_writer.end_tag(node)
      buffer_writer.ending if pos != 1
    end
  end
end