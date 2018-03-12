# class BufferWriter : it write standard strings into a buffer
class BufferWriter

  def write(statement)
    "writer.write #{statement}"
  end

  def begin_tag(node)
    write "\'<#{node.name}\' + formatter.attributes_string(attributes) + \'>\'"
  end

  def pretty_tag(node)
    write "\'<#{node.name}\' + formatter.attributes_string(attributes) + \'/>\'"
  end
  
  def end_tag(node)
    write "\'</#{node.name}>\'"
  end

  def text_content(node)
    write "\'#{node.attributes.to_s}\'"
  end

  def comment_content(node)
    write"\'<!--#{node.attributes}-->\'"
  end

  def meta_content(node)
    write"\'<#{node.name}\' + formatter.attributes_string(attributes) + \'/>\'"
  end

  def doctype_content(node)
    write "\'#{node.attributes}\'"
  end
  
  def initial_declaration(declaration)
    "#{declaration}{"
  end

  def begining
    "begin"
  end
  
  def ending
    "end"
  end

  def final_declaration
    "}"
  end

  def newline
    ""
  end

  def if_statement(attribute)
    "if booleanize EvalExpression.parse(context, \'#{attribute}\')"
  end

  def unless_statement(attribute)
    "unless booleanize EvalExpression.parse(context, \'#{attribute}\')"
  end

  def switch_statement(attribute, switch_var)
    "#{switch_var} = EvalExpression.parse(context, \'#{attribute}\')"
  end

  def case_statement(attribute, switch_var)
    "if #{switch_var}.eql?(EvalExpression.parse(case_context, \'#{attribute}\'))"
  end

  def attributes_statement(node)
    "attributes = #{node.attributes}.to_a.join(\' \')"
  end

  def delete_attribute_default(key)
    "attributes.delete('data-th-'+ \'#{key}\')"
  end  
end
