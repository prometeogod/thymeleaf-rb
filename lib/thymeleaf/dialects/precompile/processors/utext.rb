require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
# UTextProcessor
class UTextPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length: nil, object: nil)
    BufferWriter.write_node_head(node, buffer) if pos == 1
    evaluable, expr = Evaluation.evalue(attribute)
    if evaluable
      BufferWriter.write buffer,  'writer.write ' +  'expresion.call(context,'+'"' +expr+'"' + ').to_s'
    else
      BufferWriter.write buffer,  'writer.write ' + '"' + expr + '"'
    end
    BufferWriter.write_newline(buffer)
    if pos == length
      BufferWriter.write_node_tail(node, buffer)
      BufferWriter.write buffer,  'end' if pos != 1
      BufferWriter.write_newline(buffer)
    end
  end
end