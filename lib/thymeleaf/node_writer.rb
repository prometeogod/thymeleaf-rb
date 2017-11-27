# Class NodeWriter: implements writing and printing of nodes 
class NodeWriter
  # Operations that print on stdout
  def self.write_head(node)
    print "<#{node.name}#{node.to_s_attr}>"
  end

  def self.write_tail(node)
    print "</#{node.name}>"
  end

  # Only if a text-content node
  def self.write_text(node)
  	print "#{node.attributes.to_s}"
  end

  def self.write(string)
    print string
  end

  # Operations that write on a buffer
  def self.write_head_buffer(buffer, node)
    buffer.write("<#{node.name}#{node.to_s_attr}>")
  end

  def self.write_tail_buffer(buffer, node)
    buffer.write("</#{node.name}>")
  end

  # Only if a text-content node
  def self.write_text_buffer(buffer, node)
    buffer.write("#{node.attributes.to_s}")
  end

  def self.write_buffer(buffer, string)
    buffer.write(string)
  end

  def self.write_empty_line_buffer(buffer)
    buffer.write("\n")
  end

  def self.write_tab_buffer(buffer)
    buffer.write("\t")
  end

  def self.write_carriage_buffer(buffer)
    buffer.write("\n")
  end
end
