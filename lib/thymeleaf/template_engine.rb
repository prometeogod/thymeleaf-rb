require_relative './utils/random_string_generator'
require_relative './utils/key_words'
require_relative 'node_writer'
require_relative './precompile/precompile_buffer'
require 'json'

module Thymeleaf
  # TemplateEngine class definition
  class TemplateEngine
    
    attr_accessor :buffer
    
    def initialize
      self.buffer = PrecompileBuffer.new
    end

    def call(handler_nodes, context_holder)
      handler_nodes.each do |node|
        key = get_cache_key(context_holder, node) # Cuidado con esta operacion
        cache_manager = Thymeleaf.configuration.cache_manager
        f_cache = cache_manager.f_cache
        get_handler_nodes(f_cache, key, handler_nodes, node, context_holder)
      end
      [handler_nodes, buffer]
    end

    private

    def process_node(context_holder, node, node_list)
      # First we process the atributtes
      attr_context = process_attributes(context_holder, node, node_list)
      # Then we process the tags
      children_context = process_tag(attr_context, node, node_list)
      # Last we process the children nodes of the tree
      node.children.each do |child|
        if !key_word?(child.name)
          process_node(children_context, child, node.children)
        else # If node text-content or any keyword
          if child.markup == false
            if child.del_tail != true
              child.mark
              write_keyword_buffer(buffer, child, child.name)
            end
          end
        end
      end
      #NodeWriter.write_tail(node) if node_list.include?(node)
      if node_list.include?(node)
        if node.del_tail != true
          NodeWriter.write_tail_buffer(buffer,node)
          # NodeWriter.write_empty_line_buffer(buffer)
        end
      end
    end
 
    def write_keyword_buffer(buffer, node, keyword)
      case keyword
      when 'text-content'
        NodeWriter.write_text_buffer(buffer, node)
      when 'comment'
        comment = '<!--' + node.attributes + '-->'
        NodeWriter.write_buffer(buffer, comment)
      when 'doctype'
        NodeWriter.write_buffer(buffer, node.attributes)
      when 'meta'
        meta = '<' + node.name + node.to_s_attr + '/>'
        NodeWriter.write_buffer(buffer, meta)
      end
    end

    def process_attributes(context_holder, node, node_list)
      attr_context = context_holder
      if !key_word?(node.name)
        unless node.attributes.empty?
          node.attributes.each do |attribute_key, attribute|
            attr_context = process_attribute(attr_context, node, attribute_key, attribute, node_list)
          end
        end
      end
      attr_context
    end

    def process_attribute(attr_context, node, attribute_key, attribute, node_list)
      dialects = Thymeleaf.configuration.dialects
      # Processor and processor key
      key, processor = * dialects.find_attr_processor(attribute_key)
      process_element(attr_context, node, attribute, key, processor, node_list)
    end

    def process_tag(context_holder, node, node_list)
      dialects = Thymeleaf.configuration.dialects
      key, processor = * dialects.find_tag_processor(node.name)
      process_element(context_holder, node, nil, key, processor, node_list)
    end

    def process_element(context_holder, node, attribute, key, processor, node_list)
      subcontext = processor.call(key: key, node: node, attribute: attribute, context: context_holder, list: node_list, buffer: buffer)
      if processor_has_subcontext?(processor)
        subcontext
      else
        context_holder
      end
    end

    def processor_has_subcontext?(processor)
      processor.respond_to?(:subcontext?) && processor.subcontext?
    end

    # El determinado de la clave es esencial para que sea mas rapido
    def get_cache_key(context_holder, node)
      {
        node: node.to_html,
        context: context_holder
      }.to_s
    end

    def cached?(cache, key)
      cache.set?(key)
    end

    def get_handler_nodes(f_cache, key, handler_nodes, node, context_holder)
      if cached?(f_cache, key)
        node_cached(f_cache, key, handler_nodes, node, context_holder)
      else
        node_uncached(f_cache, key, handler_nodes, node, context_holder)
      end
    end

    def node_cached(f_cache, key, handler_nodes, node, _context_holder)
      new_node = f_cache.get(key)
      ind = handler_nodes.index(node)
      handler_nodes.delete_at(ind)
      handler_nodes.insert(ind, new_node)
    end

    def node_uncached(f_cache, key, handler_nodes, node, context_holder)
      if !key_word?(node.name)
        process_node(context_holder, node, handler_nodes)
      else 
        # Precompile
        write_keyword_buffer(buffer, node, node.name)
        #
      end
      f_cache.set(key, node)
      handler_nodes
    end
  end
end
