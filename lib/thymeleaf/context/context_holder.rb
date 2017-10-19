require_relative 'context_struct'
# ContextHolder class definition
class ContextHolder < Struct.new(:context, :parent_context)
  def initialize(context, parent_context = nil)
    if context.is_a? Hash
      super(ContextStruct.new(context), parent_context)
    else
      super(context, parent_context)
    end
  end

  def evaluate(expr)
    instance_eval(expr.to_s)
  end

  def method_missing(m, *args)
    if context.respond_to? m
      context.send(m, *args)
    elsif !parent_context.nil?
      parent_context.send(m, *args)
    end
  end

  def root
    if parent_context.nil?
      context
    else
      parent_context.root
    end
  end

  def to_s
    string = '{'
    context.to_h.each do |key, value|
      if value.is_a?(Array)
        string += to_s_child(value)
      else
        string += key.to_s + ':' + value.to_s
      end
      string += ',' unless context.to_h.to_a.last.last == value
    end
    string += '}'
  end

  private

  def to_s_child(array)
    string = '['
    array.each do |element|
      if element.is_a?(ContextStruct)
        string += to_s_child_context(element.to_h)
      elsif element.is_a?(Array)
        string += to_s_child(element) unless element.nil?
      else
        string += element.to_s unless element.nil?
      end
      string += ',' unless array.last == element
    end
    string += ']'
    string
  end

  def to_s_child_context(contextstruct)
    string = '{'
    contextstruct.each do |key, value|
      if value.is_a?(Array)
        string += key.to_s + ':' + (to_s_child(value) unless value.nil?)
      else
        string += key.to_s + ':' + value.to_s
      end
      string += ',' unless contextstruct.to_a.last.last == value
    end
    string += '}'
    string
  end
end
