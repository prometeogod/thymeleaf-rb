require 'thymeleaf'
# DefaultProcessor test
describe DefaultProcessor do
  def context
    ContextHolder.new(ContextStruct.new)
  end

  it 'renders data attribute without concatenation' do
    key = 'placeholder'
    fragment = '<input data-th-placeholder="new"/>'
    handler = Thymeleaf::Parser.new(fragment).call
    old_attr = { key => 'initial' }
    node = NodeTree.new('input', old_attr)
    parsed_template = handler.nodes
    attr = parsed_template[0].attributes['data-th-placeholder']
    processor = DefaultProcessor
    processor.new.call(key: key, node: node, attribute: attr, context: context)
    assert_equal 'new', node.attributes[key]
  end
end
