require_relative 'precompile/precompiler'
require_relative 'precompile/writer'
require_relative 'precompile/expresion'
require_relative 'context/context_holder'
require_relative './cache/node_value_date'
require_relative 'processor'
require_relative './utils/name_parser'


module Thymeleaf
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

    def do_render(template, filename=nil)
      # clave para cache de precompiladas
      dig = Digest::SHA1.hexdigest(template)
      # Intenta pillar la plantilla precompilada en la cache
      precompiled_template = Thymeleaf.configuration.pre_cache.get(dig)
      if !precompiled_template
  	    # Mirar si esta en la cache de parsed_templates
        parsed_tree = get_parsed_template(template, filename) # Parseado
        precompiled_template = precompile(parsed_tree) #Es un lambda
        Thymeleaf.configuration.pre_cache.set(dig, precompiled_template)
      end
      w = StringWriter.new
      precompiled_template.call(context, w, Expr.new)
      w.output
    end

    def precompile(parsed_tree)
      precompiled_template = Precompiler.new.precompile(parsed_tree) #Es un lambda
      eval(precompiled_template)
    end

    # Template file open

    def template_file_open(template_file)
      File.open template_file do |template|
        template.rewind
        yield template.read
      end
    end

    # Get parsed tree

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