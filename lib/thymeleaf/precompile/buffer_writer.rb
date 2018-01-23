# class BufferWriter : it write standard strings into a buffer
require_relative '../utils/attributes_utils'
class BufferWriter
  def self.write_node_head(node, buffer)
    reg_attrs = select_regular(node.attributes)
    s_reg_attr = to_string_regular_attributes(reg_attrs)
  	buffer.write 'writer.write' + '\'' +'<' + node.name + s_reg_attr + '>' + '\'' 
    write_newline(buffer)
  end

  def self.write_node_tail(node, buffer)
  	buffer.write 'writer.write' + '\'' +'</' + node.name + '>' + '\''
    write_newline(buffer)
  end

  def self.write_text_node(node, buffer)
    buffer.write 'writer.write'+  '\''+ node.attributes.to_s + '\''
    write_newline(buffer)
  end
  
  def self.write_comment_node(node, buffer)
    buffer.write 'writer.write'+ '\''+ '<!--' + node.attributes + '-->' + '\''
    write_newline(buffer)
  end

  def self.write_initial_declaration(buffer, declaration)
    buffer.write declaration + '{'
    write_newline(buffer)
  end

  def self.write_final_declaration(buffer)
    buffer.write '}'
  end

  def self.write_newline(buffer)
    buffer.write "\n"
  end

  def self.write(buffer, statement)
    buffer.write statement
  end
end