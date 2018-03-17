class DefaultProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    node.attributes.delete(('data-th-' + key))
    default_value = "EvalExpression.parse(context, \'#{attribute}\')"
    node_instruction.attributes.from_default[key] = default_value
  end
end