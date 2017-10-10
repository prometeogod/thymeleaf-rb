
require 'nokogiri'

module ThymeleafNoko

  class Parser < Struct.new(:template_markup)
    def call
      if /^\s*(?:\s*<!--[^>]*-->)*\s*<(?:html|!doctype)/i.match(template_markup)
        Nokogiri::HTML(template_markup, ThymeleafNoko.configuration.parser.encoding)
      else
        Nokogiri::HTML::fragment(template_markup, ThymeleafNoko.configuration.parser.encoding)
      end
    end
  end

end
