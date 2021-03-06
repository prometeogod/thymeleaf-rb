require_relative './utils/key_words'
# NodeTree class definition : Structure to recreate the HTML template
class NodeTree
  attr_accessor :name, :attributes, :children, :parent

  def initialize(name, attributes = {}, children = [], parent = nil)
    @name = name
    @attributes = attributes
    @children = children
    @parent = parent
    
  end

  def delete
    parent = self.parent
    parent.children.delete(self) unless parent.nil?
  end

  def add_child(node)
    children.push(node)
    node.parent = self
  end

  def append(list)
    list.each do |node|
      self.add_child(node)
    end
    self
  end

  def add_next_sibling(node)
    index = parent.children.index(self)
    parent.children.insert(index + 1, node)
    node.parent = parent
  end

  def add_previous_sibling(node)
    parent = self.parent
    index = parent.children.index(self)
    parent.children.insert(index, node)
    node.parent = parent
  end

  def replace(other)
    parent = self.parent
    index = parent.children.index(self)
    parent.children.delete_at(index)
    other.parent = parent
    parent.children.insert(index, other)
  end

  def deep_clone
    Marshal.load(Marshal.dump(self))
  end

  def to_html
    string = ''
    string + (key_word?(name) ? to_html_text(self) : to_html_regular(self))
  end

  private

  def to_html_text(node, string = '')
    case node.name
    when 'text_content'
      string << node.attributes
    when 'comment'
      string << "<!--#{node.attributes}-->"
    when 'doctype'
      string << node.attributes
    when 'meta'
      string << "<#{node.name}#{to_s_attributes(node.attributes)} />"
    when 'root'
      string
    end
    node.children.each{|child| string += child.to_html}
    string
  end

  def to_html_regular(node, string = '')
    string += '<' + node.name + to_s_attributes(node.attributes) + '>'
    string += to_html_regular_child(node.children) unless node.children.empty?
    string += ('</' + node.name + '>')
    string
  end

  def to_html_regular_child(nodes, str = '')
    nodes.each do |n|
      condition = key_word?(n.name)
      str += (condition ? to_html_text(n) : to_html_regular(n))
    end
    str
  end

  def to_s_attributes(attributes)
    string = ''
    attributes.each do |key, value|
      string += (' ' + key.to_s + '=' + '"' + value + '"')
    end
    string
  end
end
