require 'test_helper'
require 'thymeleaf/cache/nodeValueDate'

describe NodeValueDate do 
	before(:each) do 
		@node = NodeValueDate.new(2)
	end
	it 'should create a NodeValueDate object ' do 
		assert_equal @node.value, 2
		date = Time.new(2000,1,2,3)
		node1 = NodeValueDate.new('value',date)
		assert_equal node1.value , 'value'
		assert_equal node1.date , date
	end

	it 'should create a NodeValueDate object with a list' do
		nvd_list=NodeValueDate.new([1,2,3])
		assert_equal nvd_list.value , [1,2,3]
		result = nvd_list.date.instance_of?(Time)
		assert_equal result ,true
	end
	
	
end