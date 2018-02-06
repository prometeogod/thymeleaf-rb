# class BufferWriter : it write standard strings into a buffer
require_relative '../attributes'
class BufferWriter
  def initialize(buffer)
    @buffer = buffer
  end

  def write(statement)
    buffer.write statement
  end

  def begin_tag(node)
    attribute_utils = Attributes.new
    html_attributes = attribute_utils.select_html_attributes(node.attributes)
    string_reg = attribute_utils.to_string_regular_attributes(html_attributes)
    write "writer.write \'<#{node.name + string_reg}>\'" 
  end

  def end_tag(node)
    write "writer.write \'<\\#{node.name}>\'"
  end

  def text_content(node)
    write "writer.write \'#{node.attributes.to_s}\'"
  end

  def comment_content(node)
    write "writer.write \'<!--#{node.attributes}-->\'"
  end
  
  def initial_declaration(declaration)
    write "#{declaration}{"
  end

  def begining
    write "begin"
  end
  
  def ending
    write "end"
  end

  def final_declaration
    write "}"
  end

  def newline
    write ""
  end

  private 

  attr_accessor :buffer
end
