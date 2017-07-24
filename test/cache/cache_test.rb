require 'test_helper'
require 'thymeleaf/cache/cache'

describe Cache do 
	before(:each) do 
		@cache = Cache.new
	end
	it 'should create a cache object ' do 
		assert_equal @cache.count, 0
	end

	it 'should be one when a object is cached' do
		assert_equal @cache.count , 0
		@cache.set("string","this is a string")
		assert_equal @cache.count , 1
		assert_equal @cache.limit , nil
	end

	it 'should return value when you use get with a key' do
		@cache.set("string","this is a string")
		assert_equal @cache.get("string") , "this is a string"
		assert_equal @cache.count , 1
	end

	it 'should return value when you delete with a key' do
		@cache.set("string","this is a string")
		assert_equal @cache.count , 1
		assert_equal @cache.delete("string"), "this is a string"
		assert_equal @cache.count , 0
	end

	it 'should clear the cache' do
		c = Cache.new(5)
		c.set(1,1)
		c.set(2,2)
		assert_equal c.count , 2
		assert_equal c.limit , 5
		c.clear 
		assert_equal c.count ,0		
	end

	it 'should return values as an array' do 
		@cache.set(1,1)
		@cache.set(2,2)
		a = @cache.to_a
		assert_equal a.kind_of?(Array) , true
	end
end