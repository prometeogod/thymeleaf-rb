require_relative 'nodetree'
# SaxHandler class definition : It handles the Sax Parser events
class SaxHandler
  attr_reader :nodes, :names

  def initialize
    @nodes = []
    @names = []
  end

  # Actions to perform on element
  def on_element(_namespace, name, attrs = {})
    # Create a node and add it to the correspondent place
    name_node = name
    node = NodeTree.new(name_node, attrs)
    parent = @names.last
    if !parent.nil?
      parent.add_child(node)
    else
      @nodes << node
    end
    @names << node
  end

  # Actions to perform after element
  def after_element(_namespace, _name)
    @names.pop
  end

  # Actions to perform when is text
  def on_text(text)
    node_text = NodeTree.new('text_content', text)
    parent = @names.last
    if parent.nil?
      @nodes << node_text
    else
      parent.add_child(node_text)
    end
  end

  # Returns a html string from the handler
  def to_html(nodes = @nodes, string = '')
    nodes.each do |node|
      string += node.to_html
    end
    string
  end

  def on_comment(comment)
    node_comment = NodeTree.new('comment', comment)
    parent = @names.last
    if parent.nil?
      @nodes << node_comment
    else
      parent.add_child(node_comment)
    end
  end

  def on_doctype(node)
    doctype_string = output_doctype(node)
    node_doctype = NodeTree.new('doctype', doctype_string)
    parent = @names.last
    if parent.nil?
      @nodes << node_doctype
    else
      parent.add_child(node_doctype)
    end
  end

  #  def on_document;end

  #  def on_cdata;end

  #  def on_proc_ins;end

  #  def on_xml_decl;end

  #  def on_element_children;end

  # def on_attribute;end

  # def on_attributes;end

  private

  def output_doctype(node)
    output = ''
    output << "<!DOCTYPE #{node[:name]}"
    output << " #{node.type}" if node[:type]
    output << %("#{node.public_id}") if node[:public_id]
    output << %("#{node.system_id}") if node[:system_id]
    output << " [#{node.inline_rules}]" if node[:inline_rules]
    output << '>'
  end
end
