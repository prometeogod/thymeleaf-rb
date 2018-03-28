# class BufferWriter : it write standard strings into a buffer
class StatementFactory
  REMOVE_ALL           = 'all'.freeze
  REMOVE_BODY          = 'body'.freeze
  REMOVE_TAG           = 'tag'.freeze
  REMOVE_ALL_BUT_FIRST = 'all-but-first'.freeze
  REMOVE_NONE          = 'none'.freeze
  
  def write(statement)
    "writer.write #{statement}"
  end

  def begin_tag(node)
    write "\'<#{node.name}\' + formatter.attributes_string(attributes) + \'>\'"
  end

  def pretty_tag(node)
    write "\'<#{node.name}\' + formatter.attributes_string(attributes) + \'/>\'"
  end
  
  def end_tag(node)
    write "\'</#{node.name}>\'"
  end

  def text_content(node)
    write "\'#{node.attributes.to_s}\'"
  end

  def comment_content(node)
    write"\'<!--#{node.attributes}-->\'"
  end

  def meta_content(node)
    write"\'<#{node.name}\' + formatter.attributes_string(attributes) + \'/>\'"
  end

  def doctype_content(node)
    write "\'#{node.attributes}\'"
  end
  
  def initial_declaration(declaration)
    "#{declaration}{"
  end

  def begining
    "begin"
  end
  
  def ending
    "end"
  end

  def final_declaration
    "}"
  end

  def newline
    ""
  end

  def if_statement(attribute)
    ["if booleanize EvalExpression.parse(context, \'#{attribute}\')",ending]
  end

  def unless_statement(attribute)
    ["unless booleanize EvalExpression.parse(context, \'#{attribute}\')",ending]
  end

  def text_statement(attribute)
    write "Oga::XML::Entities.encode(EvalExpression.parse(context,\'#{attribute}\'))"
  end

  def utext_statement(attribute)
    write "EvalExpression.parse(context,\'#{attribute}\')" 
  end

  def switch_statement(attribute, switch_var)
    attribute_instructions = []
    attribute_instructions << "case_context = ContextHolder.new({}, context)"
    attribute_instructions << "#{switch_var} = EvalExpression.parse(context, \'#{attribute}\')"
    attribute_instructions
  end

  def case_statement(attribute, switch_var)
    ["if #{switch_var}.eql?(EvalExpression.parse(case_context, \'#{attribute}\'))",ending]
  end

  def root_statement(declaration)
    ["#{declaration}{","}"]
  end

  def meta_statement(node)
    ["attributes = #{node.attributes}",meta_content(node)]
  end

  def doctype_statement(node)
    doctype_content(node)
  end

  def comment_statement(node)
    comment_content(node)
  end

  def default_statement(attribute)
    "EvalExpression.parse(context, \'#{attribute}\')"
  end

  def replace_statement(attribute, fragment_var)
    attribute_instructions = []
    before_children = []

    attribute_instructions << "template, fragment = FragmentExpression.parse(context, \'#{attribute}\')"
    attribute_instructions << ["if (template==\'this\' || template.nil?)", ending]
    attribute_instructions << "unless fragment.nil?"
    attribute_instructions << "if fragment.match(/#^*/).nil?"
    attribute_instructions << "eval(\'#{fragment_var}_\' + fragment)"
    attribute_instructions << "else"
    # DOM Replacement
    attribute_instructions << ending
    attribute_instructions << ending
    attribute_instructions << "else"

    before_children << "subtemplate = EvalExpression.parse(context, template)"
    before_children << (write "formatter.print_extern_template(subtemplate, context, fragment)")

    [attribute_instructions, before_children]
  end

  def remove_statement(attribute, children)
    statements = remove_statement_init
    statements[0] << ["unless (expr==\'#{REMOVE_ALL}\' || expr == \'true\' )", ending]
    statements[0] << "expr = EvalExpression.parse(context, \'#{attribute}\')"

    statements[1] << "unless (expr == \'#{REMOVE_BODY}\')"

    statements[2] << [nil,"unless (expr ==\'#{REMOVE_TAG}\')"]
    statements[2] << [nil, ending]
    statements[2] << "unless (expr ==\'#{REMOVE_TAG}\')"

    statements[3] << ending

    statements[4] << [nil, ending]
    unless children.empty?
      statements[2] << [nil, ending]
      statements[5] << [nil, "unless (expr == \'#{REMOVE_ALL_BUT_FIRST}\')"]
    end

    statements
  end

  def object_statement(attribute)
    statements = []
    statements << ["eval(\%(->(context,writer, formatter){","})).call(context,writer, formatter)"]
    statements << "obj_var = EvalExpression.parse_single_expression(context, \'#{attribute}\')"
    statements << "context = ContextHolder.new({}, obj_var)"
    statements
  end

  

  def insert_statement(attribute, fragment_var)
    attribute_instructions = []
    attribute_instructions << "template, fragment = FragmentExpression.parse(context, \'#{attribute}\')"

    child_attribute_instructions = []
    child_attribute_instructions << ["if (template==\'this\' || template.nil?)", ending]
    child_attribute_instructions << "unless fragment.nil?"
    child_attribute_instructions << "if fragment.match(/#^*/).nil?"
    child_attribute_instructions << "eval(\'#{fragment_var}_\' + fragment)"
    child_attribute_instructions << "else"
    # DOM Replacement
    child_attribute_instructions << ending
    child_attribute_instructions << ending
    child_attribute_instructions << "else"

    child_before_children = []
    child_before_children << "subtemplate = EvalExpression.parse(context, template)"
    child_before_children << (write "formatter.print_extern_template(subtemplate, context, fragment)")

    [attribute_instructions, child_attribute_instructions, child_before_children]
  end

  def attributes_statement(node)
    "attributes = #{node.attributes}.to_a.join(\' \')"
  end

  def delete_attribute_default(key)
    "attributes.delete('data-th-'+ \'#{key}\')"
  end

  private 

  def remove_statement_init
    [[], [], [], [], [], []]
  end
end
