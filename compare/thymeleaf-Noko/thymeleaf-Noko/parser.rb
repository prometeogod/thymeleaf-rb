
require 'nokogiri'

module ThymeleafNoko
  class Parser < Struct.new(:template_markup)
    def call
      encoding = ThymeleafNoko.configuration.parser.encoding
      if /^\s*(?:\s*<!--[^>]*-->)*\s*<(?:html|!doctype)/i.match(template_markup)
        Nokogiri::HTML(template_markup, encoding)
      else
        Nokogiri::HTML.fragment(template_markup, encoding)
      end
    end
  end
end
