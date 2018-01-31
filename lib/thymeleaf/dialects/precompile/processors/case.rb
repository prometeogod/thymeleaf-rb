require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
class CasePreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length: nil, object: nil)
    evaluable, expr = Evaluation.evalue(attribute)
    if evaluable
      BufferWriter.write buffer, 'when ' + 'expresion.call(context,'+'"' +expr+'"' + ')' 
    else
      BufferWriter.write buffer, 'when ' + '"' + expr + '"' 
    end
    BufferWriter.write buffer, 'begin'
    BufferWriter.begin_tag(buffer, node) if pos == 1
    if pos == length
      if !node.children.empty?
        precompiler = Thymeleaf::Precompiler.new
        precompiler.precompile_children(node.children, buffer)
      end
      BufferWriter.end_tag(buffer, node)
      BufferWriter.write buffer, 'end'
    end
  end
end