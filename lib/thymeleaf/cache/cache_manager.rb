require_relative '../nodetree'
require_relative 'cache'
require_relative 'store'
require_relative 'node_value_date'
require 'json'

# CacheManager definition : Controls the E/S operations for the Cache
class CacheManager
  attr_accessor :p_cache, :f_cache

  def clear_caches
    p_cache.reset
    f_cache.reset
  end

  def p_cache
    self.p_cache = Store.new
  end

  def f_cache
    self.f_cache = Store.new
  end
end
