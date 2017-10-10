require 'thymeleaf/dialects/default/processors/default'
require 'thymeleaf/context/context_struct'
require 'thymeleaf/context/context_holder'
require 'thymeleaf/nodetree'

describe DefaultProcessor do

  def context
    ContextHolder.new(ContextStruct.new())
  end

  #it 'renders data attribute without concatenation' do
  #  node = {'placeholder'=>'initial'}
  #  attr = Nokogiri::HTML::DocumentFragment.parse('<input data-th-placeholder="new"/>').children[0].attributes["data-th-placeholder"]
  #  DefaultProcessor.new.call(key: 'placeholder', node: node, attribute: attr, context: context)
  #  assert_equal 'new', node['placeholder']
  #end
end
