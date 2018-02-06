
class EachPreprocessor
  include Thymeleaf::Processor
  def call(node: nil, buffer_writer: nil, precompiler: nil, attribute: nil, pos: nil, length:nil, object: nil)
    buffer_writer.write "in_context = ContextHolder.new(context)"
    each_variable = PrecompileDialect::EACH_ELEMENT
    buffer_writer.write "#{each_variable}, stat, enumerable = EachExpression.parse(in_context,\'#{attribute}\')"
    buffer_writer.write "elements = expresion.call(context,enumerable)"
    if pos == 1
      buffer_writer.begin_tag(node)
    end
    buffer_writer.write "elements.each do |#{each_variable}|"
    if node.children.any?
      precompiler.precompile_children(node.children, buffer_writer, each_variable)
    end
    if pos==length
      buffer_writer.ending
      buffer_writer.end_tag(node)
    end
  end

  private

end