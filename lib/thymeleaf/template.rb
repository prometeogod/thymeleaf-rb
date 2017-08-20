
require_relative 'processor'

module Thymeleaf
  
  require_relative 'context/context_holder'

  class Template < Struct.new(:template_markup, :context)
    def render(filename=nil)
      do_render template_markup ,filename
    end
    
    def render_file
      template_markup_uri = Thymeleaf.configuration.template_uri(template_markup)
      template_file_open template_markup_uri do |template|
        do_render template
      end
    end
  
  private
    def do_render(template , filename=nil)
      if !filename.nil?
      cache_name= filename+ '.th.parsed_cache'
        if !Thymeleaf.configuration.cache_manager.parsed_cache.get(cache_name).nil?
          cache_value = Thymeleaf.configuration.cache_manager.parsed_cache.get(cache_name)
          parsed_template = cache_value
        else
          handler = ParserSax.new(template).call
          parsed_template=handler.nodes
          Thymeleaf.configuration.cache_manager.parsed_cache.set(cache_name,parsed_template)
          #Thymeleaf.configuration.cache_manager.
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

  end
end