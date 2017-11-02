require 'test_helper'
require 'thymeleaf'

describe SaxHandler do
  it 'should return a html string' do
    fragment = '<input data-th-placeholder="new"/>'
    parsed_fragment = '<input data-th-placeholder="new"></input>'

    handler = Thymeleaf::Parser.new(fragment).call
    assert_equal handler.to_html.is_a?(String), true
    assert_equal handler.to_html, parsed_fragment
  end
end
