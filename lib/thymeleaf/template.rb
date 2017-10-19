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
      if !filename.nil?
        cache_name = to_cache_name(filename.dup, '.th.parsed_cache')
        name_parsed = cache_name.split('.th.parsed_cache')[0]
        cache_manager = Thymeleaf.configuration.cache_manager
        if !cache_manager.parsed_cache.get(cache_name).nil? # If is cached
          cache_value = cache_manager.parsed_cache.get(cache_name)
          parsed_template = cache_value.value
          cache_date = cache_value.date
          file_date = get_template_file_mtime(filename)
          date_comparison = cache_date <=> file_date
          if date_comparison == -1
            cache_manager.parsed_cache.delete(cache_name)
            handler = Parser.new(template).call
            parsed_template = handler.nodes
            node = NodeValueDate.new(parsed_template)
            cache_manager.parsed_cache.set(cache_name, node)
            cache_manager.write_file_cache(parsed_template, name_parsed)
            # TODO, realizar la escritura en memoria en otro momento
          end
        else # If isn't cached
          handler = Parser.new(template).call
          parsed_template = handler.nodes
          node = NodeValueDate.new(parsed_template)
          cache_manager.parsed_cache.set(cache_name, node)
          cache_manager.write_file_cache(parsed_template, name_parsed)
          # TODO, realizar la escritura en memoria en otro momento
        end
      else
        handler = Parser.new(template).call
        parsed_template = handler.nodes
      end
      context_holder = ContextHolder.new(context)
      TemplateEngine.new.call(parsed_template, context_holder)
      to_rendered_string(parsed_template)
    end

    def template_file_open(template_file)
      File.open template_file do |template|
        template.rewind
        yield template.read
      end
    end

    def get_template_file_mtime(file)
      File.mtime(file)
    end

    def to_rendered_string(parsed_template)
      rendered = ''
      parsed_template.each do |node|
        if !node.to_html.nil?
          rendered += node.to_html
        else
          rendered += "\n"
        end
      end
      rendered
    end
  end
end
