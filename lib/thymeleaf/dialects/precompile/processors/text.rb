require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
# TextPreprocessor
class TextPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length: nil, object: nil)
    # Header
    if pos == 1
      BufferWriter.begin_tag(buffer, node)
    end
    # Body
    evaluable, expr = Evaluation.evalue(attribute)
    if object
       object_expr = Evaluation.asterisk_object(expr, object) # TODO no me gusta este metodo
       BufferWriter.write buffer, 'writer.write ' +  'Oga::XML::Entities.encode(' +  object_expr + ')'
    else
      # Escape the text
      if evaluable
        BufferWriter.write buffer, 'writer.write ' + 'Oga::XML::Entities.encode('+ 'expresion.call(context,'+'"' +expr+'"' + ').to_s' + ')'
      else 
        BufferWriter.write buffer, 'writer.write ' + 'Oga::XML::Entities.encode('+ '"' + expr + '"' + ')'
      end
    end
    # Tail
    if pos == length
      BufferWriter.end_tag(buffer, node)
      BufferWriter.write buffer, 'end' if pos != 1
    end
  end
end