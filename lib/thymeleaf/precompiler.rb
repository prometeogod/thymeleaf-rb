require_relative 'precompile/precompile_buffer'
require_relative 'precompile/buffer_writer'
require_relative '../thymeleaf'
require_relative 'precompile/writer'
require_relative 'instructions'
require_relative 'node_instruction'
# class Precompiler : implements the mechanism that precompiles parsed templates
module Thymeleaf
  class Precompiler
    def initialize(parsed_template = nil)
      @parsed_template = parsed_template
    end

    def precompile
      eval_function(template_function)
    end

    private 

    attr_accessor :parsed_template

    def template_function
      buffer = PrecompileBuffer.new
      buffer_writer = BufferWriter.new
      process_template(parsed_template, buffer_writer).to_buffer(buffer)
      buffer.flush
    end
  
    def eval_function(function)
      eval(function)
    end

    def process_template(template, buffer_writer)
      root = NodeInstruction.new
      process_node(template, root, nil, buffer_writer)
      process_nodes(template.children, root, buffer_writer)
      root
    end
  
    def process_nodes(nodes, parent_instruction, buffer_writer)
      nodes.each do |node|
        node_instruction = NodeInstruction.new
        parent_instruction.add_child(node_instruction)
        process_node(node, node_instruction, parent_instruction, buffer_writer)
      end
    end

    def process_node(node, node_instruction, parent_instruction, buffer_writer)
      if key_word?(node.name)
        process_html_node(node, node_instruction, parent_instruction, buffer_writer)
      else
        process_dialect_node(node, node_instruction, parent_instruction, buffer_writer)
      end     
    end
  
    def process_html_node(node, node_instruction, parent_instruction, buffer_writer)
      dialects = Thymeleaf.configuration.dialects 
      key, processor = * dialects.find_html_processor(node.name)
      process_element(node, node_instruction, parent_instruction, buffer_writer, nil, key, processor)    
    end
  
    def process_dialect_node(node, node_instruction, parent_instruction, buffer_writer)
      process_attributes(node, node_instruction, parent_instruction, buffer_writer)
      process_tag(node, node_instruction, parent_instruction, buffer_writer)
      process_nodes(node.children, node_instruction, buffer_writer)
    end

    def process_attributes(node,node_instruction, parent_instruction, buffer_writer)
      node.attributes.each do |attribute_key, attribute|
        process_attribute(node, node_instruction, parent_instruction, buffer_writer, attribute_key, attribute)
      end
    end

    def process_attribute(node, node_instruction, parent_instruction, buffer_writer, attribute_key, attribute)
      dialects = Thymeleaf.configuration.dialects
      key, processor = * dialects.find_attr_processor(attribute_key)
      process_element(node, node_instruction, parent_instruction, buffer_writer, attribute, key, processor)
    end
  
    def process_tag(node, node_instruction, parent_instruction, buffer_writer)
      dialects = Thymeleaf.configuration.dialects
      key, processor = * dialects.find_tag_processor(node.name)
      process_element(node,node_instruction, parent_instruction, buffer_writer, nil, key, processor)
    end

    def process_element(node, node_instruction, parent_instruction, buffer_writer, attribute, key, processor)
      processor.call(node: node, node_instruction: node_instruction, parent_instruction: parent_instruction, buffer_writer: buffer_writer, attribute: attribute, key: key)
    end
  end
end
