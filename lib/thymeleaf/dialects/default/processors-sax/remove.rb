require_relative '../../../utils/booleanize'

class RemoveProcessorSax
  include Thymeleaf::Processor

  REMOVE_ALL           = 'all'
  REMOVE_BODY          = 'body'
  REMOVE_TAG           = 'tag'
  REMOVE_ALL_BUT_FIRST = 'all-but-first'
  REMOVE_NONE          = 'none'

  def call(node:nil, attribute:nil, context:nil, list:nil, **_)
    node.attributes.delete('data-th-remove')
    
    expr = EvalExpression.parse(context, attribute)

    method = case expr
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
                 if booleanize expr
                   :remove_all
                 else
                   :remove_none
                 end
               end
    
    send(method, node, list, context)
  end

  private

  def remove_none(_, _, _)
  end

  def remove_all(node, list, _)
  	node.children.each do |child|
  	  node.children.delete(child)
  	end
  	list.delete(node)
  end

  def remove_body(node, list, _)
  	node.children=[]
  end

  def remove_tag(node,list, context)
    node.children.reverse.each do |child|
      subprocess_node(context, child, list)
      node.add_next_sibling child
    end
    list.delete(node)
  end
  def remove_allbutfirst(node, list, _)
  	first=get_first_non_empty(node.children).dup
  	node.children.clear
  	node.add_child(first)
  end
  def empty_node?(node)
    node.to_s.strip.empty?
  end
  
  def get_first_non_empty(node_set)
    node_set.each do |child|
      if child.name=='text-content' and !empty_node?(child.attributes)
      	return child
      else
      	if child.name != 'text-content'
      		return child
      	end
      end
    end
  end

end