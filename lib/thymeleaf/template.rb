require_relative 'processor'
require_relative './utils/name_parser'


module Thymeleaf
  
  require_relative 'context/context_holder'
  require_relative './cache/nodeValueDate'

  class Template < Struct.new(:template_markup, :context)
    def render(filename=nil)
      do_render template_markup ,filename
    end
    
    def render_file
      template_markup_uri = Thymeleaf.configuration.template_uri(template_markup)
      cache_name=to_cache_name(template_markup_uri.dup)
      template_file_open template_markup_uri do |template|
        do_render template ,template_markup_uri
      end
    end
  
  private
    def do_render(template , filename=nil)
      
      if !filename.nil?
        cache_name=to_cache_name(filename.dup,'.th.parsed_cache')
        name_parsed=cache_name.split('.th.parsed_cache')[0]
        if !Thymeleaf.configuration.cache_manager.parsed_cache.get(cache_name).nil? # If is cached
          cache_value = Thymeleaf.configuration.cache_manager.parsed_cache.get(cache_name)
          parsed_template = cache_value.value
          cache_date = cache_value.date
          file_date = get_template_file_mtime(filename)
          date_comparison= cache_date <=> file_date
          if (date_comparison == -1)
            Thymeleaf.configuration.cache_manager.parsed_cache.delete(cache_name)
            handler = ParserSax.new(template).call
            parsed_template=handler.nodes
            node = NodeValueDate.new(parsed_template)
            Thymeleaf.configuration.cache_manager.parsed_cache.set(cache_name,node)
            Thymeleaf.configuration.cache_manager.write_file_cache(parsed_template,name_parsed,node.date)# TODO realizar la escritura en memoria en otro momento
          end
        else # If isn't cached
          handler = ParserSax.new(template).call
          parsed_template=handler.nodes
          node = NodeValueDate.new(parsed_template)
          Thymeleaf.configuration.cache_manager.parsed_cache.set(cache_name,node)
          Thymeleaf.configuration.cache_manager.write_file_cache(parsed_template,name_parsed,node.date)# TODO realizar la escritura en memoria en otro momento
        end
      else
        handler = ParserSax.new(template).call
        parsed_template=handler.nodes
      end
      context_holder = ContextHolder.new(context)
      TemplateEngineSax.new.call(parsed_template, context_holder)
      rendered=""
      parsed_template.each do |node|
        if !node.to_html.nil?
          rendered+= node.to_html
        else 
          rendered+= "\n"
        end
        rendered
      end
      rendered
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

  end
end