require_relative '../../../nodetree'
class TextProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    child_text = EvalExpression.parse(context, attribute)
   	child_text = escape_text(child_text)
    child = NodeTree.new('text-content',child_text)
    node.children.clear
    node.add_child(child)
    node.attributes.delete('data-th-text')
  end

  private
  def escape_text(string)
    new_string=''
    string.each_char do |char|
      if char == '"'
        new_string+='&quot;'
      elsif char == '&'
        new_string+='&amp;'
      elsif char == '<'
        new_string+='&lt;'
      elsif char == '>'
        new_string+='&gt;'
      else
        new_string+=char    
      end         
    end
    new_string
  end
end