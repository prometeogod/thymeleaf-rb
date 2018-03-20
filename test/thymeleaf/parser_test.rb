require 'test_helper'
require 'thymeleaf'

describe Thymeleaf::Parser do
  it 'parse a comment' do
  	comment = '<!-- Just a comment -->'
  	parsed_comment = Thymeleaf::Parser.new(comment).call
  	assert_equal parsed_comment.to_html, comment
  end

  it 'parse a doctype' do 
    doctype = '<p><!DOCTYPE html></p>'
    parsed_doctype = Thymeleaf::Parser.new(doctype).call
  	assert_equal parsed_doctype.to_html, doctype
  end

  it 'parse a text_content' do 
    text = 'Text'
    parsed_text = Thymeleaf::Parser.new(text).call
    assert_equal parsed_text.to_html, text
  end

  it 'parse a meta tag' do  
    meta = '<meta charset=UTF-8 />'
    result = '<meta charset="UTF-8" />'
    parsed_meta = Thymeleaf::Parser.new(meta).call
    assert_equal parsed_meta.to_html, result
  end 
end