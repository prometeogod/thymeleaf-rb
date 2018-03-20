require_relative '../thymeleaf'
class Formatter
  include Thymeleaf::Processor
  def attributes_string(attributes)
    string = ''
    attributes.each{|key,value| string += (" #{key.to_s}=\"#{value}\"")}
    string
  end

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

  def print_extern_template(template_name, context, fragment)
    writer = Writer.new
    template = get_extern_template(template_name)
    template = find_subfragment(fragment, template) unless fragment.nil?
    precompiled = Thymeleaf::Precompiler.new(template).precompile
    precompiled.call(context, writer, self)
    writer.output
  end

  private 
  
  def get_extern_template(template_name)
    load_template template_name do |template_file|
      Thymeleaf::Parser.new(template_file).call
    end
  end

  def find_subfragment(fragment_name, template)
    nodes = find_subfragment_node(fragment_name, template)
    root = NodeTree.new('root')
    root.append(nodes)
  end 

  def find_subfragment_node(fragment_name, node, solution= [])
    solution << node if subfragment_condition(fragment_name, node.attributes)
    find_subfragment_children(fragment_name, node.children, solution)
    solution
  end

  def find_subfragment_children(fragment_name, nodes, solution)
    nodes.each { |node| find_subfragment_node(fragment_name, node, solution)}
  end 

  def subfragment_condition(fragment_name, attributes)
    attributes.is_a?(Hash) && attributes.any?{|k,v| k.eql?('data-th-fragment')&& v.eql?(fragment_name)}
  end
end
