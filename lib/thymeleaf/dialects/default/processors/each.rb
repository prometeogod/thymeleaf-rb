# EachProcessor class definition : it process each tags
class EachProcessor
  include Thymeleaf::Processor
  require_relative '../parsers/each'

  def call(node: nil, attribute: nil, context: nil, list: nil, buffer: nil, **_)
    variable, stat, enumerable = EachExpression.parse(context, attribute)
    # Node markup
    print_list = []
    if !node.marked?
      node.mark
      node.delete_tail
      node.mark_decendents
      node.delete_tail_decendents
      print_list << node
    end
    #
    elements = evaluate_in_context(context, enumerable)
    stat_var = init_stat_var(stat, elements)
    node.attributes.delete('data-th-each')
    elements.each do |element|
      subcontext_vars = {}
      subcontext_vars[variable] = element unless variable.nil?
      unless stat.nil?
        stat_var[:index]  += 1
        stat_var[:count]  += 1
        stat_var[:current] = element
        stat_var[:even] = stat_var[:count].even?
        stat_var[:odd] = stat_var[:count].odd?
        stat_var[:first] = (stat_var[:index].eql? 0)
        stat_var[:last] = (stat_var[:count].eql? stat_var[:size])
        subcontext_vars[stat] = stat_var
      end
      subcontext = ContextHolder.new(subcontext_vars, context)
      new_node = node.deep_clone
      #
      new_node.mark
      new_node.mark_decendents
      #
      subprocess_node(subcontext, new_node, list)
      node.add_previous_sibling(new_node)
    end
    # Precompile buffer
    if print_list.include?(node)
      write_buffer(buffer, node.marshalled)
    end
    #
    node.children.clear
    list.delete(node)
    context
  end

  def subcontext?
    true
  end

  private

  def init_stat_var(stat, elements)
    if stat.nil?
      nil
    else
      {
        index: -1,
        count: 0,
        size: elements.length,
        current: nil,
        even: false,
        odd: true,
        first: true,
        last: false
      }
    end
  end

  def write_buffer(buffer, marshall_list)
    marshall_list.each do |element|
      NodeWriter.write_buffer(buffer, element.to_html)
    end
    NodeWriter.write_empty_line_buffer(buffer)
  end
end
