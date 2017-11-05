require 'mini_cache'
require 'singleton'
# FragmentCache class definition inherits from MiniCache::Store
# include Singleton module
class FragmentCache < MiniCache::Store
  include Singleton
end
