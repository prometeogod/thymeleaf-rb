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
      root_node = root_node(buffer_writer)
      process_nodes(parsed_template, root_node, buffer_writer)
      root_node.to_buffer(buffer)
      buffer.flush
    end
  
    def root_node(buffer_writer)
      initial_instruction = buffer_writer.initial_declaration('->(context, writer, expresion, formatter)')
      final_instruction = buffer_writer.final_declaration
      instruction = Instruction.new(initial_instruction, final_instruction)
      instructions = Instructions.new
      instructions.especial_instructions << instruction
      NodeInstruction.new(instructions)
    end

    def eval_function(function)
      eval(function)
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
        process_especial_node(node, node_instruction, parent_instruction, buffer_writer)
      else
        process_normal_node(node, node_instruction, parent_instruction, buffer_writer)
      end      
    end
  
    def process_especial_node(node, node_instruction, parent_instruction, buffer_writer)
      case node.name
      when 'text-content'
        instruction = Instruction.new(buffer_writer.text_content(node))
      when 'comment'
        instruction = Instruction.new(buffer_writer.comment_content(node))
      when 'doctype'
      
      when 'meta'
      
      end
      node_instruction.instructions.especial_instructions << instruction
    end
  
    def process_normal_node(node, node_instruction, parent_instruction, buffer_writer)
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
