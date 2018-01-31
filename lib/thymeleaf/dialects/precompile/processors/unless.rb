require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
require_relative '../../../../../lib/thymeleaf'
class UnlessPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length: nil, object: nil)
    evaluable, expr = Evaluation.evalue(attribute)
    BufferWriter.write buffer, 'unless ' + 'booleanize '+ 'expresion.call(context,'+'"' +expr+'"' + ').to_s'
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