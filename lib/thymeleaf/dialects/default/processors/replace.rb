require_relative  'insert'

class ReplaceProcessor < InsertProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, list:nil,**_)
    node.attributes.delete('data-th-replace')
    template, fragment = FragmentExpression.parse(context, attribute)
    
    node_subcontent = get_node_template(template, node, context)
    
    node.children=[]

    if fragment.nil?
      # Avoid infinite loop when template is "this" and fragment is nil
      return nil if is_self_template? template
    else
      node_subcontent = get_fragment_node(fragment, context, node_subcontent)
    end

    unless node_subcontent.nil?
      if node_subcontent.kind_of?(Array)
      	node_subcontent.each do |subnode|
          subnode = subnode.dup
          subprocess_node(context,subnode,list)
          node.replace subnode
        end 
      else

      	node_subcontent = node_subcontent.dup
      	subprocess_node(context, node_subcontent,list)

       	node.replace node_subcontent
      end
    end
  end
end