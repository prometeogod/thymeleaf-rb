require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
require_relative '../../../../../lib/thymeleaf'
class SwitchPreprocessor
  def call(node: nil, buffer: nil, attribute: nil, pos: nil, length: nil, object: nil)
  	BufferWriter.begin_tag(buffer, node)
  	evaluable, expr = Evaluation.evalue(attribute)
  	BufferWriter.write buffer, 'case '+'expresion.call(context,'+'"' +expr+'"' + ')'
  	if !node.children.empty?
      precompiler = Thymeleaf::Precompiler.new
      precompiler.precompile_notext_children(node.children, buffer)
    end
    BufferWriter.write buffer, 'end'
    BufferWriter.end_tag(buffer, node)
  end
end