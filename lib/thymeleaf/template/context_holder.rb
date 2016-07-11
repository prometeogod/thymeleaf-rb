
class ContextHolder < Struct.new(:context, :parent_context)

  def initialize(context, parent_context = nil)
    if context.is_a? Hash
      super(OpenStruct.new(context), parent_context)
    else
      super(context, parent_context)
    end
  end

  def evaluate(expr)
    instance_eval(expr)
  end

  def method_missing(m, *args)
    if context.respond_to? m
      context.send(m, *args)
    elsif !parent_context.nil?
      parent_context.send(m, *args)
    end
  end
end