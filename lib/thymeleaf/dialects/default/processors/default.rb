class DefaultProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, statement_factory: nil, attribute: nil, key: nil)
    node.attributes.delete(('data-th-' + key))
    node_instruction.attributes.from_default[key] = statement_factory.default_statement(attribute)
  end
end