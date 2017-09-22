module Thymeleaf
  class TemplateEngineSax
  	
  	def call(handler_nodes, context_holder)
  	  handler_nodes.each do |node|
        cache_key = get_cache_key(context_holder,node)#This operation is expensive in time
        if Thymeleaf.configuration.cache_manager.fragment_cache.get(cache_key).nil?
          filename = to_filename(cache_key,cache_key.length/10)#This operation is expensive in time
          if node.name != 'text-content'
            process_node(context_holder,node,handler_nodes)
          end
          Thymeleaf.configuration.cache_manager.fragment_cache.set(cache_key,node)
          Thymeleaf.configuration.cache_manager.write_file_fragment(node,cache_key,filename)#TODO Do the write in an exit event
          
        else
          new_node=Thymeleaf.configuration.cache_manager.fragment_cache.get(cache_key)
          ind = handler_nodes.index(node)
          handler_nodes.delete_at(ind)
          handler_nodes.insert(ind,new_node)
        end
      end
      handler_nodes
  	end

  	private

  	def process_node( context_holder, node,node_list)
        #First we process the atributtes
        attr_context=process_attributes(context_holder, node, node_list)
        #Then we process the tags
        children_context = process_tag(attr_context, node, node_list)
        #Last we process the children nodes of the tree
        node.children.each do|child|
          if child.name != 'text-content'
            process_node(children_context, child, node.children)
          end
        end
  	end

	  def process_attributes(context_holder , node, node_list)
      attr_context = context_holder
      if node.name != 'text-content'
        if !node.attributes.empty?
          node.attributes.each do |attribute_key, attribute|
            attr_context = process_attribute(attr_context, node, attribute_key, attribute, node_list)
          end
        end
      end
      attr_context
	  end

    def process_attribute(attr_context, node, attribute_key, attribute, node_list)
      dialects = Thymeleaf.configuration.dialects
      key, processor = * dialects.find_attr_processor(attribute_key) #Processor and processor key
      process_element(attr_context, node, attribute, key, processor, node_list)
	   end

	  def process_tag(context_holder, node, node_list)
      dialects = Thymeleaf.configuration.dialects
      key, processor = * dialects.find_tag_processor(node.name)
     
      process_element(context_holder, node, nil, key, processor, node_list)
	  end

   	def process_element(context_holder, node, attribute, key, processor, node_list)
      subcontext = processor.call(key: key, node: node, attribute: attribute, context: context_holder, list: node_list)
      if processor_has_subcontext?(processor)
        subcontext
      else
        context_holder
      end
	  end

	  def processor_has_subcontext?(processor)
      processor.respond_to?(:has_subcontext?) && processor.has_subcontext?
	  end

    def get_cache_key(context_holder, node)
      context_string = context_holder.to_s
      node_string = node.to_html
      if node_string.nil?
        cache_key=context_string
      else
        cache_key=context_string + node_string
      end
      cache_key
    end
     
      
    
    def to_filename(cache_key,jump)
      name=cache_key
      len=name.length
      if (jump!=0)
        num=len/jump
        i=0
        str=''
        while i<num+1
          if (i*jump+(jump-1))<len
            str1=name[i*jump..i*jump+(jump-1)]
          else
            str1=name[i*jump..len]
          end
          str+=str1.crypt("aa")
          i+=1
        end
        str=str.gsub(/[\/.]/, '_')
      else
        str=name.crypt("aa")
        str=str.gsub(/[\/.]/, '_')
      end
      str
    end

  end
end