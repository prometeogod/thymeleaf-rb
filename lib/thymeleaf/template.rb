require_relative 'processor'
require_relative './utils/name_parser'
# Thymeleaf module
module Thymeleaf
  require_relative 'context/context_holder'
  require_relative './cache/node_value_date'
  # Template class definition: defines the operations to render templates
  class Template < Struct.new(:template_markup, :context)
    def render(filename = nil)
      do_render template_markup, filename
    end

    def render_file
      configuration = Thymeleaf.configuration
      template_markup_uri = configuration.template_uri(template_markup)
      template_file_open template_markup_uri do |template|
        do_render template, template_markup_uri
      end
    end

    private

    def do_render(template, filename = nil)
      if !precompiled(template, context)
        parsed_template = get_parsed_template(template, filename)
        context_holder = ContextHolder.new(context)
        parsed_template, buffer = TemplateEngine.new.call(parsed_template, context_holder)
        # Set the buffer to the cache
        key = template + context.to_s
        Thymeleaf.configuration.cache_manager.pre_cache.set(key, buffer)
        buffer.to_html
      else
        buffer = Thymeleaf.configuration.cache_manager.pre_cache.get(template + context.to_s)
        buffer.to_html
      end
    end

    def precompiled(template, context)
      key = template + context.to_s
      buffer = Thymeleaf.configuration.cache_manager.pre_cache.get(key)
      if buffer != nil 
        true
      else
        false
      end
    end

    def template_file_open(template_file)
      File.open template_file do |template|
        template.rewind
        yield template.read
      end
    end

    def to_rendered_string(parsed_template)
      rendered = ''
      parsed_template.each do |node|
        if !node.to_html.nil?
          rendered += node.to_html
        else
          rendered += "\n" # TODO, Beware this \n
        end
      end
      rendered
    end

    def get_parsed_template(template, filename)
      if !filename.nil?
        key = to_cache_name(filename.dup, '.th.parsed_cache')
        cache_manager = Thymeleaf.configuration.cache_manager
        p_cache = cache_manager.p_cache
        template_caching(p_cache, key, template, filename)
      else
        handler = Parser.new(template).call
        handler.nodes
      end
    end

    def template_caching(p_cache, key, template, filename)
      if cached?(p_cache, key)
        node_cached(p_cache, key, template, filename)
      else
        node_uncached(p_cache, key, template, filename)
      end
    end

    def node_cached(p_cache, key, template, filename)
      nodevd = p_cache.get(key)
      cache_date = nodevd.date
      file_date = get_template_file_mtime(filename)
      parsed_template = nodevd.value
      date_comparison = cache_date <=> file_date
      if date_comparison == -1
        parsed_template = node_recached(p_cache, key, template)
      end
      parsed_template
    end

    def node_recached(p_cache, key, template)
      p_cache.unset(key)
      handler = Parser.new(template).call
      parsed_template = handler.nodes
      node = NodeValueDate.new(parsed_template)
      p_cache.set(key, node)
      parsed_template
    end

    def node_uncached(p_cache, key, template, _filename)
      handler = Parser.new(template).call
      parsed_template = handler.nodes
      node = NodeValueDate.new(parsed_template)
      p_cache.set(key, node)
      parsed_template
    end

    def cached?(cache, key)
      cache.set?(key)
    end

    def get_template_file_mtime(file)
      File.mtime(file)
    end
  end
end
