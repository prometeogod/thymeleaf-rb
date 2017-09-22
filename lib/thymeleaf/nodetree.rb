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
    parent=self.parent
    index=parent.children.index(self)
    parent.children.insert(index+1,node)
    node.parent=parent
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
  def hard_copy
    new_node = NodeTree.new(self.name)
    if self.name=='text-content'
      new_node.attributes=self.attributes
    else
      new_node.attributes=copy_attributes(self.attributes)
    end
    self.children.each do |child|
      new_child=child.hard_copy
      new_node.add_child(new_child)
    end
    new_node
  end

  def to_string_cache(i=0,array_parent=[],array_string=[],array_nodes=[])
    i+=1
    array_string=to_string_cache_node(i,array_parent,array_string)
    array_parent.delete_at(0)
    array_nodes.delete(array_nodes.first)
    self.children.each do |child|
      array_parent << i
      array_nodes << child
    end
    array_nodes.each do |node|
      node.to_string_cache(i,array_parent,array_string,array_nodes)
    end
    array_string
  end

  def to_array_fragment(count=0,parent=0,array_cache=[])
    count+=1
    parent+=1
    array_cache << to_string_array_line(count,self.name,self.attributes,0);
    count,array=to_array_fragment_child(self.children,count,parent,[])
    array_cache= array_cache+array
    array_cache
  end

  def to_array_fragment_child(node_list,count,parent,array)
    count+=1
    node_list.each do |node|
      array << to_string_array_line(count,node.name,node.attributes,parent)
      count,array=to_array_fragment_child(node.children,count,count,array) if !node.children.nil?
    end
    [count,array]
  end
  def to_string_array_line(i,name,attributes,parent)
    separator='&sep'
    string=(i).to_s+separator
    string+=(name.to_s)+separator
    if name.to_s == 'text-content'
      string+= attributes.to_s+separator
    else
      string+= to_s_attributes_cache(attributes)+separator
    end
    string+=parent.to_s
    string
  end

  private
  
  def to_string_cache_node(i,array_parent,array_string)
    string=(i).to_s+';'
    string+=(self.name)+';'
    if self.name == 'text-content'
      string+= self.attributes+';'
    else
      string+= to_s_attributes_cache(self.attributes)+';'
    end
    if array_parent.empty?
      string+=0.to_s
    else
      string+=array_parent.first.to_s
    end
    array_string << string
    array_string
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

  def to_s_attributes_cache(attributes)
    string = ''
    attributes.each do |key, value|
      string += string += (''+key.to_s + '=' +'"' +value +'"'+'/,') 
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

  def copy_attributes(attributes)
    new_attributes={}
    attributes.each{|key,value| new_attributes.store(key,value)}
    new_attributes
  end
end
