require_relative './utils/key_words'
# NodeTree class definition : Structure to recreate the HTML template
class NodeTree
  attr_accessor :name, :attributes, :children, :parent

  def initialize(name, attributes = {}, children = [], parent = nil)
    self.name = name
    self.attributes = attributes
    self.children = children
    self.parent = parent
  end

  def add_child(node)
    children.push(node)
    node.parent = self
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

  def to_h
    {
      name: name,
      attributes: attributes,
      children: to_h_children(children)
    }
  end

  def to_html
    string = ''
    condition = key_word?(name)
    string + (condition ? to_html_text(self) : to_html_regular(self))
  end

  def to_s_attr
    to_s_attributes(self.attributes)
  end

  private

  def to_h_children(children)
    list = []
    children.each do |child|
      hash = {
        name: child.name,
        attributes: child.attributes,
        children: to_h_children(child.children)
      }
      list << hash
    end
    list
  end

  def to_html_text(node)
    case node.name
    when 'text-content'
      node.attributes
    when 'comment'
      '<!--' + node.attributes + '-->'
    when 'doctype'
      node.attributes
    when 'meta'
      '<' + node.name + to_s_attributes(node.attributes) + '/>'
    end
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
