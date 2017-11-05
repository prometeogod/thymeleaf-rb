require 'mini_cache'
require 'singleton'
# ParsedCache class definition inherits from MiniCache::Store
# include Singleton module
class ParsedCache < MiniCache::Store
  include Singleton
end
