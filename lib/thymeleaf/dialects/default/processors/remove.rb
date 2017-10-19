require_relative '../../../utils/booleanize'
# RemoveProcessor class definition : it process remove
class RemoveProcessor
  include Thymeleaf::Processor

  REMOVE_ALL           = 'all'.freeze
  REMOVE_BODY          = 'body'.freeze
  REMOVE_TAG           = 'tag'.freeze
  REMOVE_ALL_BUT_FIRST = 'all-but-first'.freeze
  REMOVE_NONE          = 'none'.freeze

  def call(node: nil, attribute: nil, context: nil, list: nil, **_)
    node.attributes.delete('data-th-remove')

    expr = EvalExpression.parse(context, attribute)

    method = get_method_remove(expr)

    send(method, node, list, context)
  end

  private

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
      subprocess_node(context, child, list)
      node.add_next_sibling child
    end
    list.delete(node)
  end

  def remove_allbutfirst(node, _list, _)
    first = get_first_non_empty(node.children).dup
    node.children.clear
    node.add_child(first)
  end

  def empty_node?(node)
    node.to_s.strip.empty?
  end

  def get_first_non_empty(node_set)
    node_set.each do |child|
      cond1 = child.name == 'text-content' && !empty_node?(child.attributes)
      cond2 = child.name != 'text-content'
      return child if cond1 || cond2
    end
  end
end
