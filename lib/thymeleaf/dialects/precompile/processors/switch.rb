require_relative '../../../precompile/buffer_writer'
require_relative '../../../precompile/evaluation'
require_relative '../../../../../lib/thymeleaf'
class SwitchPreprocessor
  def call(node: nil, buffer: nil, buffer_writer: nil, attribute: nil, pos: nil, length: nil, object: nil)
  	buffer_writer.begin_tag(node)
  	evaluable, expr = Evaluation.evalue(attribute)
  	buffer_writer.write "case expresion.call(context,\'#{expr}\')"
  	if !node.children.empty?
      precompiler = Thymeleaf::Precompiler.new
      precompiler.precompile_notext_children(node.children, buffer, buffer_writer)
    end
    buffer_writer.ending
    buffer_writer.end_tag(node)
  end
end