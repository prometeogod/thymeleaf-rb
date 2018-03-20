require 'test_helper'
require 'thymeleaf'

describe SaxHandler do
  it 'should return a html string' do
    fragment = '<input data-th-placeholder="new"/>'
    parsed_fragment = '<input data-th-placeholder="new"></input>'

    parsed_template = Thymeleaf::Parser.new(fragment).call
    assert_equal parsed_template.is_a?(NodeTree), true
    html_string = parsed_template.to_html
    assert_equal html_string, parsed_fragment
  end
end
