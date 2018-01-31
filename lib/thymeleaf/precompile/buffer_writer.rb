# class BufferWriter : it write standard strings into a buffer
require_relative '../utils/attributes_utils'
class BufferWriter
  def self.begin_tag(buffer, node)
    reg_attrs = select_regular(node.attributes)
    s_reg_attr = to_string_regular_attributes(reg_attrs)
  	buffer.write "writer.write \'<#{node.name + s_reg_attr}>\'" 
  end

  def self.end_tag(buffer, node)
  	buffer.write "writer.write \'<#{node.name}>\'"
  end

  def self.text_content(buffer, node)
    buffer.write "writer.write \'#{node.attributes.to_s}\'"
  end
  
  def self.comment_content(buffer, node)
    buffer.write "writer.write \'<!--#{node.attributes}-->\'"
  end

  def self.initial_declaration(buffer, declaration)
    buffer.write "#{declaration}{"
  end

  def self.write_final_declaration(buffer)
    buffer.write "}"
  end

  def self.write_newline(buffer)
    buffer.write ""
  end

  def self.write(buffer, statement)
    buffer.write statement
  end
end
