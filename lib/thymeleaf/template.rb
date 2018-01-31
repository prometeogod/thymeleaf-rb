require_relative 'precompile/writer'
require_relative 'precompile/expresion'
require_relative 'context/context_holder'
require_relative 'processor'

module Thymeleaf
  # Class Template
  class Template < Struct.new(:template_markup, :context)
    def render
      precompiled_template = precompiled_template(template_key(template_markup), template_markup)
      output_template(context, Writer.new, Expression.new, precompiled_template)
    end

    private

    def template_key(template)
      Thymeleaf::TemplateKey.new(template).key
    end

    def parsed_template(template)
      Thymeleaf::Parser.new(template).call
    end

    def precompile(parsed_template)
      Thymeleaf::Precompiler.new(parsed_template).precompile
    end

    def precompiled_template_from_cache(template_key)
      Thymeleaf.configuration.precompile_cache.get(template_key)
    end

    def fetch_precompiled_template(template_key, template)
      precompiled_template = precompile(parsed_template(template))
      Thymeleaf.configuration.precompile_cache.set(template_key, precompiled_template)
      precompiled_template
    end

    def precompiled_template(template_key, template)
      precompiled_template_from_cache(template_key) || fetch_precompiled_template(template_key, template)
    end

    def output_template(context, writer, expression, template)
      template.call(context, writer, expression)
      writer.output
    end
  end
end
