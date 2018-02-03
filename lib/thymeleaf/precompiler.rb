require_relative 'precompile/precompile_buffer'
require_relative 'precompile/buffer_writer'
require_relative '../thymeleaf'
require_relative 'precompile/writer'
require_relative 'utils/attributes_utils'
# class Precompiler : implements the mechanism that precompiles parsed templates
module Thymeleaf
class Precompiler
  
  def initialize(parsed_template = nil)
    @parsed_template = parsed_template
  end
  def precompile
    buffer = PrecompileBuffer.new
    buffer_writer = BufferWriter.new(buffer)
    buffer_writer.initial_declaration('->(context, writer, expresion)')
    parsed_template.each do |node|
      if key_word?(node.name)
        precompile_with_keyword(node, buffer, buffer_writer)
      else
        precompile_node(node, buffer, buffer_writer)
      end
    end
    buffer_writer.final_declaration
    puts fl = buffer.flush
    eval(fl) # 
  end

  def precompile_children(children, buffer, buffer_writer, object = nil)
    children.each do |child|
      if key_word?(child.name)
        precompile_with_keyword(child, buffer, buffer_writer)
      else
        precompile_node(child, buffer, buffer_writer, object)
      end
    end
  end

  def precompile_notext_children(children, buffer, buffer_writer)
    children.each do |child|
      if !key_word?(child.name)
        precompile_node(child, buffer, buffer_writer)
      end
    end
  end
  
  private 

  attr_accessor :parsed_template
  
  def precompile_with_keyword(node, buffer, buffer_writer)
    precompile_keyword(node, buffer, buffer_writer)
  end

  def precompile_keyword(node, buffer, buffer_writer)
    case node.name
    when 'text-content'
      buffer_writer.text_content(node)
    when 'comment'
      buffer_writer.comment_content(node)
    when 'doctype'
      
    when 'meta'
      
    end
  end

  def precompile_node(node, buffer, buffer_writer, object = nil)
    # First we process the attributes
    if node.name.match(/th-^*/) # Detecta si es procesar el tag
        process_tag(node, buffer, buffer_writer)
    else
      if !node.attributes.empty?
        process_attributes(node, buffer, buffer_writer, object)
      else     
        buffer_writer.begin_tag(node)
        if !node.children.empty?
          precompile_children(node.children, buffer, buffer_writer, object)
        end
        buffer_writer.end_tag(node)
      end
    end
  end

  def process_attributes(node, buffer, buffer_writer, object=nil)
    pos = 0
    length = length_th(node.attributes)
    node.attributes.each do |attribute_key, attribute|
      processor = find_processor(attribute_key)
      if processor
        pos += 1 if processor.class != NullPreprocessor
        process_element(processor, node, buffer, buffer_writer, attribute, pos, length, object)
      end
    end
  end

  def process_tag(node, buffer, buffer_writer)
    processor = find_tag_processor(node.name)
    if processor
      process_element(processor, node, buffer, buffer_writer, nil, nil, nil)
    end
  end

  def process_element(processor, node, buffer, buffer_writer, attribute, pos, length, object = nil)
    processor.call(node: node, buffer: buffer, buffer_writer: buffer_writer, precompiler: self, attribute: attribute, pos: pos, length: length, object: object)
  end

  def find_processor(attribute_key)
    dialects = Thymeleaf.configuration.dialects
    key, processor = * dialects.find_attr_processor(attribute_key)
    processor
  end

  def find_tag_processor(node_name)
    dialects = Thymeleaf.configuration.dialects
    key, processor = * dialects.find_tag_processor(node_name)
    processor
  end
end
end