require 'thymeleaf/dialects/dialect'

class ExampleDialect < Dialect
  def self.default_key
    'say'
  end
  # Precedence based on order
  def processors
    {
        hello: HelloProcessor,
        # ’default’ key is required
        default: Thymeleaf::NullProcessor
    }
  end
  
  class HelloProcessor
    include Thymeleaf::Processor
    #def call(node:nil, attribute:nil, **_)
    #  node.content = 'Hello'
    #  attribute.unlink
    #end
    def call(node:nil, attribute:nil, **_)
      node.attributes.delete('data-say-hello')
      node.children.clear
      content = NodeTree.new('text-content','Hello')
      node.add_child(content)
    end
  end
end