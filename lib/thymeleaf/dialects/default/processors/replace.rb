require_relative 'insert'
# ReplaceProcessor class definition : it process replace tag
# it inherits from InsertProcessor
class ReplaceProcessor < InsertProcessor
  include Thymeleaf::Processor

  def call(node: nil, attribute: nil, context: nil, list: nil, buffer: nil, **_)
    node.attributes.delete('data-th-replace')
    template, fragment = FragmentExpression.parse(context, attribute)

    node_subcontent = get_node_template(template, node, context)

    node.children.clear

    if fragment.nil?
      # Avoid infinite loop when template is "this" and fragment is nil
      return nil if self_template? template
    else
      node_subcontent = get_fragment_node(fragment, context, node_subcontent)
    end

    return if node_subcontent.nil?

    process_node_subcontent(node_subcontent, node, context, list)
    # Precompile buffer
    write_buffer(buffer, node, node_subcontent)
    #
  end

  private
  
  def write_buffer(buffer, node, node_subcontent)
    node.mark
    node.mark_decendents
    node.delete_tail
    node.delete_tail_decendents
    if !node_subcontent.is_a?(Array)
      NodeWriter.write_buffer(buffer, node_subcontent.to_html)
    else
      node_subcontent.each do |sub|
        NodeWriter.write_buffer(buffer, sub.to_html)
      end
    end
  end

  def process_node_subcontent(node_subcontent, node, context, list)
    if node_subcontent.is_a?(Array)
      node_subcontent.each do |subnode|
        subnode = subnode.dup
        subprocess_node(context, subnode, list)
        node.replace subnode
      end
    else
      node_subcontent = node_subcontent.dup
      subprocess_node(context, node_subcontent, list)

      node.replace node_subcontent
    end
  end
end
