# InsertProcessor class definition : it process insert tags
class InsertProcessor
  include Thymeleaf::Processor

  require_relative '../parsers/fragment'

  def call(node: nil, attribute: nil, context: nil, **_)
    node.attributes.delete('data-th-insert')
    template, fragment = FragmentExpression.parse(context, attribute)
    node_subcontent = get_node_template(template, node, context)
    node.children = []
    if fragment.nil?
      # Avoid infinite loop when template is "this" and fragment is nil
      return nil if self_template? template
    else
      node_subcontent = get_fragment_node(fragment, context, node_subcontent)
      node.add_child(node_subcontent)
    end
    return if node_subcontent.nil?
    if node_subcontent.is_a?(Array)
      node_subcontent.each do |sub|
        node.add_child(sub)
      end
    else
      node_subcontent.dup.parent = node
    end
    
  end

  private

  def get_node_template(template, node, context)
    if self_template? template
      root_node node
    else
      subtemplate = EvalExpression.parse(context, template)
      load_template subtemplate do |template_file|
        Thymeleaf::Parser.new(template_file).call.nodes
      end
    end
  end

  def root_node(node)
    new_node = node
    new_node = new_node.parent until new_node.parent.nil?
    new_node
  end

  def self_template?(template)
    template.nil? || (template.eql? 'this')
  end

  def get_fragment_node(fragment_name, context, node)
    root_context = context.root

    if root_context.private? DefaultDialect.context_fragment_var(fragment_name)
      root_context.get_private DefaultDialect.context_fragment_var(fragment_name)
    else
      fragment_name = fragment_name.delete(fragment_name[0])
      get_dom_replacement(fragment_name, root_node(node))
    end
  end

  def get_dom_replacement(fragment_name, root)
    root.attributes.each_pair do |key, value|
      return root if key == 'id' && value == fragment_name
    end
    get_fragment_dom_replacement(fragment_name, root.children) unless root.children.empty?
  end

  def get_fragment_dom_replacement(fragment_name, template)
    template.each do |node|
      next unless !key_word?(node.name)
      node.attributes.each do |key, value|
        return node if key == 'id' && value == fragment_name
      end
      get_fragment_dom_replacement(fragment_name, node.children) unless node.children.empty?
    end
    nil
  end
end
