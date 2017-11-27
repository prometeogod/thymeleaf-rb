require 'mini_cache'
require 'singleton'
# PrecompileCache class definition inherits from MiniCache::Store
# include Singleton module
class PrecompileCache < MiniCache::Store
  include Singleton
end
