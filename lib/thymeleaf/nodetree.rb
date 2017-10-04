class NodeTree
  attr_accessor :name, :attributes, :children, :parent

  def initialize(name, attributes={}, children=[], parent=nil)
    self.name=name
    self.attributes=attributes
    self.children= children
   	self.parent=parent
  end

  def add_child(node)
  	self.children.push(node)
  	node.parent=self
  end

  def add_next_sibling(node)
    index=self.parent.children.index(self)
    self.parent.children.insert(index+1,node)
    node.parent=self.parent
  end

  def add_previous_sibling(node)
  	parent=self.parent
    index=parent.children.index(self)
    parent.children.insert(index,node)
    node.parent=parent
  end

  def replace(other)
    parent=self.parent
    index=parent.children.index(self)
    parent.children.delete_at(index)
    other.parent=parent
    parent.children.insert(index,other)
  end

  def to_html
    string=''
    if self.name == 'text-content'
      string+= self.attributes
      string+=to_html_child(self.children) if !self.children.empty?
    else
      string+= ('<'+self.name.gsub(/\s*-codename\d*/,'')+ to_s_attributes(self.attributes) +'>')
      string+=to_html_child(self.children) if !self.children.empty?
      string+= ('</' + self.name.gsub(/\s*-codename\d*/,'') +'>')
    end
  end

  def deep_clone
    Marshal::load(Marshal::dump(self))
  end

  def to_h
    {
      :name => self.name,
      :attributes => self.attributes,
      :children => to_h_children(self.children)
    }
  end

  private

  def to_h_children(children)
    list = []
    children.each do |child|
      hash={
        :name => child.name,
        :attributes => child.attributes,
        :children => to_h_children(child.children)
      }
      list << hash
    end
    list
  end

  def to_html_child(nodes ,string='')
    nodes.each do |node|
        if node.name == 'text-content'
          string+= node.attributes
          string+=to_html_child(node.children) if !node.children.empty?
        else
          string+= ('<'+node.name.gsub(/\s*-codename\d*/,'')+ to_s_attributes(node.attributes) +'>')
          string+=to_html_child(node.children) if !node.children.empty?
          string+= ('</' + node.name.gsub(/\s*-codename\d*/,'') +'>')
        end
      end
      string
  end

  def to_s_attributes(attributes)
    string = ''
    attributes.each do |key, value|
      string += (' '+key.to_s + '=' +'"' +value +'"') 
    end
    string
  end

end
