require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
# TextPreprocessor
class TextPreprocessor
  def call(node: nil, buffer_writer: nil, precompiler: nil, attribute: nil, pos: nil, length: nil, object: nil)
    # Header
    if pos == 1
      buffer_writer.begin_tag(node)
    end
    # Body
    #buffer_writer.write "writer.write Oga::XML::Entities.encode(EvalExpression.parse(context,\'#{attribute}\'))"
    evaluable, expr = Evaluation.evalue(attribute)
    if object
       object_expr = Evaluation.asterisk_object(expr, object) # TODO no me gusta este metodo
       buffer_writer.write "writer.write Oga::XML::Entities.encode(#{object_expr})"
    else
      # Escape the text
      if evaluable
        buffer_writer.write "writer.write Oga::XML::Entities.encode(expresion.call(context,\'#{expr}\').to_s)"
      else 
        buffer_writer.write "writer.write Oga::XML::Entities.encode(\'#{expr}\')"
      end
    end
    # Tail
    if pos == length
      buffer_writer.end_tag(node)
      buffer_writer.ending if pos != 1
    end
  end
end