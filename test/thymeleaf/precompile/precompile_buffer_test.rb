require_relative '../../test_helper'
require 'thymeleaf/precompile/precompile_buffer'

describe PrecompileBuffer do 
  before(:each) do
    @buffer = PrecompileBuffer.new
  end

  it 'should be empty' do 
    assert_equal @buffer.buffer, []
  end

  it 'should write something' do
    something = '<something>'
    @buffer.write(something)
    assert_equal @buffer.buffer.count, 1
    assert_equal @buffer.buffer[0], '<something>'
  end
end 