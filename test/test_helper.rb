$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'simplecov'
SimpleCov.start do
  add_filter "/test/"

  add_group "Template Engine", "lib"
  add_group "Benchmark", "benchmarks"
end
require 'thymeleaf'
require 'minitest/autorun'
class TestThymeleaf < Minitest::Test
 
  def render(source, context = {})
    Thymeleaf::Template.new(source, context).render
  end

  require_relative 'assertions/html'
  require_relative 'assertions/html_page'
  require_relative 'assertions/syntax_error'

end

Thymeleaf.configure do |config|
  config.template.prefix = "#{__dir__}/templates/"
  config.template.suffix = '.th.html'
end