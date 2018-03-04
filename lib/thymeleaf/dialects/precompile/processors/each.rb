
class EachPreprocessor
  include Thymeleaf::Processor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
  	node.attributes.delete('data-th-each')
  	def_method_each = Instruction.new("def each_method(context, writer, expresion, formatter)",buffer_writer.ending)
  	method_call = Instruction.new(nil,"each_method(context, writer, expresion, formatter)")
    each_variables = Instruction.new("variable, stat, enumerable = EachExpression.parse(context, \'#{attribute}\')")
    elements_variable = Instruction.new("elements = ContextEvaluator.new(context).evaluate(enumerable)")
    init_stat_var = Instruction.new("stat_var = formatter.init_stat_var(stat, elements)")
    each_statement = Instruction.new("elements.each do |element|", buffer_writer.ending)
    subcontext_vars_init =Instruction.new( "subcontext_vars = {}")
    subcontext_vars_set = Instruction.new("subcontext_vars[variable] = element unless variable.nil?")
    node_attributes = Instruction.new ("attributes = #{node.attributes}")
    unless_stat_nil = Instruction.new("unless stat.nil?")
    subcontext_each = Instruction.new("context = ContextHolder.new(subcontext_vars, context)")

    node_instruction.instructions.attribute_instructions << def_method_each
    
    node_instruction.instructions.attribute_instructions << each_variables
    
    node_instruction.instructions.attribute_instructions << elements_variable
    
    
    node_instruction.instructions.attribute_instructions << init_stat_var
    node_instruction.instructions.attribute_instructions << each_statement
   
    node_instruction.instructions.attribute_instructions << subcontext_vars_init
    node_instruction.instructions.attribute_instructions << subcontext_vars_set
   
    node_instruction.instructions.attribute_instructions << node_attributes

    node_instruction.instructions.attribute_instructions << unless_stat_nil
    update_stat(node_instruction.instructions.attribute_instructions)
    node_instruction.instructions.attribute_instructions << Instruction.new(buffer_writer.ending)
    
    node_instruction.instructions.attribute_instructions << subcontext_each
    node_instruction.instructions.attribute_instructions << method_call
  end

  private 

  def update_stat(instructions)
    instructions << Instruction.new("stat_var[:index]  += 1")
    instructions << Instruction.new("stat_var[:count]  += 1")
    instructions << Instruction.new("stat_var[:current] = element")
    instructions << Instruction.new("stat_var[:even] = stat_var[:count].even?")
    instructions << Instruction.new("stat_var[:odd] = stat_var[:count].odd?")
    instructions << Instruction.new("stat_var[:first] = (stat_var[:index].eql? 0)")
    instructions << Instruction.new("stat_var[:last] = (stat_var[:count].eql? stat_var[:size])")
    instructions << Instruction.new("subcontext_vars[stat] = stat_var")
  end
end