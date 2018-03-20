require 'thymeleaf/dialects/dialect'
# Class ExampleDialect : a test dialect
class ExampleDialect < Dialect
  def self.default_key
    'say'
  end

  # Precedence based on order
  def processors
    {
      hello: HelloProcessor,
      # default key is required
      default: NullProcessor
    }
  end
  # Class HelloProcessor: a test processor
  class HelloProcessor
    include Thymeleaf::Processor
    # def call(node:nil, attribute:nil, **_)
    #   node.content = 'Hello'
    #   attribute.unlink
    # end
    def call(node: nil, _attribute: nil, **_)
      node.attributes.delete('data-say-hello')
      node.children.clear
      content = NodeTree.new('text_content', 'Hello')
      node.add_child(content)
    end
  end
end
