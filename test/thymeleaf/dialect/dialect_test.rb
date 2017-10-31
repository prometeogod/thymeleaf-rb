$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)

require 'test_helper'
require 'thymeleaf/dialects/dialect'

describe Dialect do
  before(:each) do 
    @dia = Dialect.new
  end

  it 'should be a hash, processors' do 
    processors = @dia.processors
    assert_equal processors.is_a?(Hash), true
  end
end
