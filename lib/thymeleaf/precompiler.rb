require_relative 'precompile/precompile_buffer'
require_relative 'precompile/statement_factory'
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
      process_template(parsed_template, StatementFactory.new).to_buffer(buffer)
      buffer.flush
    end
  
    def eval_function(function)
      eval(function)
    end

    def process_template(template, statement_factory)
      root = NodeInstruction.new
      process_node(template, root, nil, statement_factory)
      process_nodes(template.children, root, statement_factory)
      root
    end
  
    def process_nodes(nodes, parent_instruction, statement_factory)
      nodes.each do |node|
        node_instruction = NodeInstruction.new
        parent_instruction.add_child(node_instruction)
        process_node(node, node_instruction, parent_instruction, statement_factory)
      end
    end

    def process_node(node, node_instruction, parent_instruction, statement_factory)
      if key_word?(node.name)
        process_html_node(node, node_instruction, parent_instruction, statement_factory)
      else
        process_dialect_node(node, node_instruction, parent_instruction, statement_factory)
      end     
    end
  
    def process_html_node(node, node_instruction, parent_instruction, statement_factory)
      dialects = Thymeleaf.configuration.dialects 
      key, processor = * dialects.find_html_processor(node.name)
      process_element(node, node_instruction, parent_instruction, statement_factory, nil, key, processor)    
    end
  
    def process_dialect_node(node, node_instruction, parent_instruction, statement_factory)
      process_attributes(node, node_instruction, parent_instruction, statement_factory)
      process_tag(node, node_instruction, parent_instruction, statement_factory)
      process_nodes(node.children, node_instruction, statement_factory)
    end

    def process_attributes(node,node_instruction, parent_instruction, statement_factory)
      node.attributes.each do |attribute_key, attribute|
        process_attribute(node, node_instruction, parent_instruction, statement_factory, attribute_key, attribute)
      end
    end

    def process_attribute(node, node_instruction, parent_instruction, statement_factory, attribute_key, attribute)
      dialects = Thymeleaf.configuration.dialects
      key, processor = * dialects.find_attr_processor(attribute_key)
      process_element(node, node_instruction, parent_instruction, statement_factory, attribute, key, processor)
    end
  
    def process_tag(node, node_instruction, parent_instruction, statement_factory)
      dialects = Thymeleaf.configuration.dialects
      key, processor = * dialects.find_tag_processor(node.name)
      process_element(node,node_instruction, parent_instruction, statement_factory, nil, key, processor)
    end

    def process_element(node, node_instruction, parent_instruction, statement_factory, attribute, key, processor)
      processor.call(node: node, node_instruction: node_instruction, parent_instruction: parent_instruction, statement_factory: statement_factory, attribute: attribute, key: key)
    end
  end
end
