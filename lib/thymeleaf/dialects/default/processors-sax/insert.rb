class InsertProcessorSax
  include Thymeleaf::Processor
  
  require_relative '../parsers/fragment'

    require_relative '../parsers/fragment'

  def call(node:nil, attribute:nil, context:nil, **_)
    node.attributes.delete('data-th-insert')
    
    
    template, fragment = FragmentExpression.parse(context, attribute)
    node_subcontent = get_node_template(template, node, context)
    node.children=[]
    if fragment.nil?
      #Avoid infinite loop when template is "this" and fragment is nil
      return nil if is_self_template? template
    else
      node_subcontent = get_fragment_node(fragment, context, node_subcontent)
      node.add_child(node_subcontent)
    end
    
    unless node_subcontent.nil?
      if node_subcontent.kind_of?(Array)
        node_subcontent.each do |sub|
          node.add_child(sub)
        end
      else
        node_subcontent.dup.parent = node
      end
    end

  end


private
  
  def get_node_template(template, node, context)
    if is_self_template? template
      root_node node
    else
      subtemplate = EvalExpression.parse(context, template)
      load_template subtemplate do |template_file|
        Thymeleaf::ParserSax.new(template_file).call.nodes
      end
    end
  end
  
  def root_node(node)
    new_node = node
    until new_node.parent.nil?
      new_node = new_node.parent
    end
    new_node
  end
  
  def is_self_template?(template)
    template.nil? || (template.eql? 'this')
  end
  
  def get_fragment_node(fragment_name, context, node)
    root_context = context.root
    
    if root_context.has_private DefaultDialectSax::context_fragment_var(fragment_name)
      root_context.get_private DefaultDialectSax::context_fragment_var(fragment_name)
    else
      fragment_name=fragment_name.delete(fragment_name[0])
      get_DOM_replacement(fragment_name,root_node(node))
    end
  end
  def get_DOM_replacement(fragment_name, root)
    root.attributes.each_pair do |key,value|
      if key=='id' and value==fragment_name
          return root 
        end
    end
    get_fragment_DOM_replacement(fragment_name, root.children) if !root.children.empty?
  end
  def get_fragment_DOM_replacement(fragment_name, template)
    template.each do |node|
      if node.name != 'text-content'
        node.attributes.each do |key, value|
          if key=='id' and value==fragment_name
            return node 
          end
        end
        get_fragment_DOM_replacement(fragment_name,node.children) if !node.children.empty?
      end
    end
    return nil
  end
end