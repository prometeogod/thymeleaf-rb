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
    unless fragment.nil?
      template = find_subfragment(fragment, template)
    end
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

  def find_subfragment(fragment_name, nodes, solution = [])
    nodes.each do |node|
      unless key_word?(node.name)
        solution << node if node.attributes.any?{|key,value| key.eql?('data-th-fragment')&& value.eql?(fragment_name)}
        find_subfragment(fragment_name, node.children, solution) unless node.children.empty?
      end
    end
    solution
  end 
end
