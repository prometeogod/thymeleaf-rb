require_relative 'nodetree'
class SaxHandler
    attr_reader :nodes , :names
    def initialize
        @nodes=[]
        @names=[]
        @element_count={}
    end

    #Actions to perform on element
    def on_element(namespace, name, attrs = {})
      #Create a node and add it to the correspondent place
      if(@element_count.has_key?(name))
        @element_count[name] += 1
      else
        @element_count[name] = 1
      end
      name_node = name
      node = NodeTree.new(name_node,attrs)
      parent=@names.last
      if !parent.nil?
        parent.add_child(node) 
      else
        @nodes << node
      end
      @names << node

    end

    #Actions to perform after element
    def after_element(namespace,name)
      @names.pop
    end
    
    #Actions to perform when is text
    def on_text(text)
      node_text = NodeTree.new('text-content',text)
      parent=@names.last
       if !parent.nil?
        parent.add_child(node_text) 
      else
        @nodes << node_text
      end
      
    end

    # Returns a html string from the handler
    def to_html(nodes = @nodes, string ='') 
      nodes.each do |node|
        if node.name == 'text-content'
          string+= node.attributes
          string+=to_html(node.children) if !node.children.empty?
        else
          string+= ('<'+ node.name + to_s_attributes(node.attributes) + '>')
          string+=to_html(node.children) if !node.children.empty?
          string+= ('</' + node.name + '>')
        end
      end
      string
    end


    private
 
    def to_s_attributes(attributes)
      string = ''
      attributes.each do |key, value|
        string += (' '+key.to_s + '=' +'"' +value +'"'+' ') 
      end
      string
    end
end