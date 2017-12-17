require 'test_helper'
require 'thymeleaf/cache/store'
describe Store do
  before(:each) do
    @cache = Store.new
  end

  it 'should store something ' do
    @cache.set('string', 'this is a string')
    assert_equal @cache.get('string'), 'this is a string'
    assert_equal @cache.count, 1
  end

  it 'should check if something is stored' do
    @cache.set('string', 'this is a string')
    assert_equal @cache.set?('string'), true
    assert_equal @cache.count, 1
  end

  it 'should delete a pair' do
    @cache.set('string', 'this is a string')
    assert_equal @cache.set?('string'), true
    assert_equal @cache.count, 1
    @cache.unset('string')
    assert_equal @cache.count, 0
    assert_equal @cache.set?('string'), false
  end

  it 'should reset the cache' do
    assert_equal @cache.count, 0
    @cache.set('string', 'this is a string')
    @cache.set('string2', 'this is a string2')
    assert_equal @cache.count, 2
    @cache.reset
    assert_equal @cache.count, 0
    assert_equal @cache.empty?, true
  end
end
