require 'thymeleaf'
require 'test_helper'
describe Thymeleaf::Configuration do
  before(:each) do 
    @conf = Thymeleaf::Configuration.new
  end

  it 'should clear all dialects' do 
  	reg_dialects = @conf.dialects.send(:registered_dialects)
  	assert_equal reg_dialects.empty? , false
  	assert_equal reg_dialects.count , 1 # The default dialect 
	
	@conf.clear_dialects
	reg_dialects = @conf.dialects.send(:registered_dialects)
	assert_equal reg_dialects.empty? , true
  	assert_equal reg_dialects.count , 0 # None  
  end
end
