require_relative 'dialects'
require_relative 'dialects/default/default_dialect'
require_relative 'template/template_resolver'
require_relative 'parser/parse_options'
require_relative 'cache/cache_manager'
# Thymeleaf module
module Thymeleaf
  class << self
    attr_accessor :configuration
  end

  # TODO: Replace accessor with getter/setter?

  def self.configure(&block)
    self.configuration ||= Configuration.new
    block.call configuration if block_given?
  end
  # Configuration class definition : Configures the template engine
  class Configuration
    attr_accessor :dialects, :template, :parser, :cache_manager
    def initialize
      self.cache_manager = CacheManager.new
      cache_manager.create_parsed_cache
      cache_manager.create_fragment_cache
      self.dialects = Dialects.new
      self.template = TemplateResolver.new
      self.parser   = ParseOptions.new
      add_dialect DefaultDialect
    end

    def add_dialect(*args)
      dialects.add_dialect(*args)
    end

    def clear_dialects
      dialects.clear_dialects
    end

    def template_uri(name)
      template.get_template(name)
    end
  end
end
