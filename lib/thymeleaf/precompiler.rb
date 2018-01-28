require_relative 'precompile/precompile_buffer'
require_relative 'precompile/buffer_writer'
require_relative '../thymeleaf'
require_relative 'precompile/writer'
require_relative 'utils/attributes_utils'
# class Precompiler : implements the mechanism that precompiles parsed templates
class Precompiler
  def precompile (parsed_tree)
    buffer = PrecompileBuffer.new
    BufferWriter.write_initial_declaration(buffer, '->(context, writer, expresion)')
    parsed_tree.each do |node|
      if key_word?(node.name)
        precompile_with_keyword(node, buffer)
      else
        precompile_node(node, buffer)
      end
    end
    BufferWriter.write_final_declaration(buffer)
    puts fl = buffer.flush
    fl
  end

  def precompile_children(children, buffer, object = nil)
    children.each do |child|
      if key_word?(child.name)
        precompile_with_keyword(child, buffer)
      else
        precompile_node(child, buffer, object)
      end
    end
  end

  def precompile_notext_children(children, buffer)
    children.each do |child|
      if !key_word?(child.name)
        precompile_node(child, buffer)
      end
    end
  end
  
  private 
  
  def precompile_with_keyword(node, buffer)
    precompile_keyword(node, buffer)
  end

  def precompile_keyword(node, buffer)
    case node.name
    when 'text-content'
      BufferWriter.write_text_node(node, buffer)
    when 'comment'
      BufferWriter.write_comment_node(node, buffer)
    when 'doctype'
      buffer.write 'print '+ 'String.new(' + '\''+ node.attributes.to_s + '\'' + ')'
    when 'meta'
      buffer.write 'print' + 'String.new(' + '\'' + '<' + node.name + node.to_s_attr + '/>' '\'' + ')'
    end
  end

  def precompile_node(node, buffer, object = nil)
    # First we process the attributes
    if node.name.match(/th-^*/) # Detecta si es procesar el tag
        process_tag(node, buffer)
    else
      if !node.attributes.empty?
        process_attributes(node, buffer, object)
      else     
        BufferWriter.write_node_head(node, buffer)
        if !node.children.empty?
          precompile_children(node.children, buffer, object)
        end
        BufferWriter.write_node_tail(node, buffer)
      end
    end
    
    # The own node needs to decide if process their childs
  end

  def process_attributes(node, buffer, object=nil)
    pos = 0
    length = length_th(node.attributes)
    node.attributes.each do |attribute_key, attribute|
      processor = find_processor(attribute_key)
      if processor
        pos += 1 if processor.class != NullPreprocessor
        process_element(processor, node, buffer, attribute, pos, length, object)
      end
    end
  end

  def process_tag(node, buffer)
    processor = find_tag_processor(node.name)
    if processor
      process_element(processor, node, buffer, nil, nil, nil)
    end
  end

  def process_element(processor, node, buffer, attribute, pos, length, object = nil)
    processor.call(node: node, buffer: buffer, attribute: attribute, pos: pos, length: length, object: object)
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
