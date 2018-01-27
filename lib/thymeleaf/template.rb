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
      
      dig = Digest::SHA1.hexdigest(template)
      
      precompiled_template = Thymeleaf.configuration.pre_cache.get(dig)
      if !precompiled_template
        handler = Thymeleaf::Parser.new(template).call
        parsed_template = handler.nodes
        precompiled_template = precompile(parsed_template) #Es un lambda
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

  end
end