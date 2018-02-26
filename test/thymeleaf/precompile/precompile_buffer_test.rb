require_relative '../../test_helper'
require 'thymeleaf/precompile/precompile_buffer'

describe PrecompileBuffer do 
  before(:each) do
    @buffer = PrecompileBuffer.new
  end

  it 'should be empty' do 
    assert_equal @buffer.empty?, true
  end

  it 'should write something' do
    something = '<something>'
    @buffer.write(something)
    assert_equal @buffer.length, 1
    assert_equal @buffer.flush, "<something>\n"
  end
end 