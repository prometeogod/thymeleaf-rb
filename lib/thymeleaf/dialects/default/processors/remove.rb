require_relative '../../../utils/booleanize'
require_relative '../../../utils/key_words'
# RemoveProcessor class definition : it process remove
class RemoveProcessor
  include Thymeleaf::Processor

  REMOVE_ALL           = 'all'.freeze
  REMOVE_BODY          = 'body'.freeze
  REMOVE_TAG           = 'tag'.freeze
  REMOVE_ALL_BUT_FIRST = 'all-but-first'.freeze
  REMOVE_NONE          = 'none'.freeze

  def call(node: nil, attribute: nil, context: nil, list: nil, buffer: nil, **_)
    node.attributes.delete('data-th-remove')
    expr = EvalExpression.parse(context, attribute)
    method = get_method_remove(expr)
    send(method, node, list, context)
    # Precompile buffer
    write_buffer(buffer, node, method)
    #
  end

  private
  
  def write_buffer(buffer, node, method)
    case method
    when :remove_all
      write_buffer_rm_all(node)
    when :remove_body
      write_buffer_rm_body(node)
    when :remove_tag
      write_buffer_rm_tag(buffer, node)
    when :remove_allbutfirst
      write_buffer_rm_allbutfirst(node)
    end
  end

  def write_buffer_rm_all(node)
    node.mark
    node.mark_decendents
    node.delete_tail
    node.delete_tail_decendents
  end

  def write_buffer_rm_body(node)
    node.mark_decendents
    node.delete_tail_decendents
  end

  def write_buffer_rm_tag(buffer, node)
    node.mark 
    node.mark_decendents
    node.delete_tail
    node.delete_tail_decendents
    node.children.each do |child|
      NodeWriter.write_buffer(buffer, child.to_html)
    end
  end

  def write_buffer_rm_allbutfirst(node)
    array = node.children
    first = get_first_non_empty(array)
    i = array.index(first)
    array.each do |child|
      if array.index(child) != i
        child.mark
        child.mark_decendents
        child.delete_tail
        child.delete_tail_decendents
      end
    end
  end

  def get_method_remove(expr)
    case expr
    when REMOVE_ALL
      :remove_all
    when REMOVE_BODY
      :remove_body
    when REMOVE_TAG
      :remove_tag
    when REMOVE_ALL_BUT_FIRST
      :remove_allbutfirst
    when REMOVE_NONE
      :remove_none
    else
      get_elsewhere_method_remove(expr)
    end
  end

  def get_elsewhere_method_remove(expr)
    if booleanize expr
      :remove_all
    else
      :remove_none
    end
  end

  def remove_none(_, _, _); end

  def remove_all(node, list, _)
    node.children.each do |child|
      node.children.delete(child)
    end
    list.delete(node)
  end

  def remove_body(node, _list, _)
    node.children = []
  end

  def remove_tag(node, list, context)
    node.children.reverse.each do |child|
      if child.name != 'text-content'
        subprocess_node(context, child, list)
        node.add_next_sibling child
      end
    end
    list.delete(node)
  end

  def remove_allbutfirst(node, _list, _)
    array = node.children
    first = get_first_non_empty(array)
    i = array.index(first)
    array.delete_if{|sub| array.index(sub) != i}
  end

  def empty_string?(attributes)
    attributes.strip.empty?
  end

  def get_first_non_empty(node_set)
    node_set.each do |child|
      cond1 = key_word?(child.name) && !empty_string?(child.attributes)
      cond2 = !key_word?(child.name)
      return child if cond1 || cond2
    end
  end
end
