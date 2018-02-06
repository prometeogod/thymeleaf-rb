require_relative 'precompile/precompile_buffer'
require_relative 'precompile/buffer_writer'
require_relative '../thymeleaf'
require_relative 'precompile/writer'
require_relative 'attributes'
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
    precompile_template(parsed_template, buffer_writer)
    buffer_writer.final_declaration
    eval_buffer(buffer)
  end

  def precompile_children(children, buffer_writer, object = nil)
    precompile_template(children, buffer_writer, object)
  end

  def precompile_notext_children(children, buffer_writer)
    children.each do |child|
      precompile_node(child, buffer_writer) unless key_word?(child.name)
    end
  end
  
  private 

  attr_accessor :parsed_template
  
  def eval_buffer(buffer)
    puts fl = buffer.flush
    eval(fl)
  end
 
  def precompile_template(template, buffer_writer, object = nil)
    template.each do |node|
      key_word?(node.name) ? precompile_with_keyword(node, buffer_writer) : precompile_node(node, buffer_writer, object)
    end 
  end

  def precompile_with_keyword(node, buffer_writer)
    precompile_keyword(node, buffer_writer)
  end

  def precompile_keyword(node, buffer_writer)
    case node.name
    when 'text-content'
      buffer_writer.text_content(node)
    when 'comment'
      buffer_writer.comment_content(node)
    when 'doctype'
      
    when 'meta'
      
    end
  end

  def precompile_node(node, buffer_writer, object = nil)
    node.name.match(/th-^*/) ? process_tag(node, buffer_writer) : process_attributes(node, buffer_writer, object)
  end

  def process_attributes(node, buffer_writer, object=nil)
    node.attributes.empty? ?  process_html_attributes(node, buffer_writer, object)  : process_dialected_attributes(node, buffer_writer, object)
  end

  def process_html_attributes(node, buffer_writer, object= nil)
    buffer_writer.begin_tag(node)
    precompile_children(node.children, buffer_writer, object) if node.children.any?
    buffer_writer.end_tag(node)
  end

  def process_dialected_attributes(node, buffer_writer, object=nil)
    pos = 0
    attribute_utils = Attributes.new
    length = attribute_utils.length_th(node.attributes)
    node.attributes.each do |attribute_key, attribute|
      processor = find_attr_processor(attribute_key)
      if processor
        pos += 1 if processor.class != NullPreprocessor
        process_element(processor, node, buffer_writer, attribute, pos, length, object)
      end
    end
  end

  def process_tag(node, buffer_writer)
    processor = find_tag_processor(node.name)
    process_element(processor, node, buffer_writer, nil, nil, nil) if processor
  end

  def process_element(processor, node, buffer_writer, attribute, pos, length, object = nil)
    processor.call(node: node, buffer_writer: buffer_writer, precompiler: self, attribute: attribute, pos: pos, length: length, object: object)
  end

  def find_attr_processor(attribute_key)
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