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
    node_text = NodeTree.new('text-content', text)
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
end
