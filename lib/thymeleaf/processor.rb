require_relative 'node_writer'
# Module Thymeleaf definition
module Thymeleaf
  # Module Processor definition
  module Processor
    require_relative 'processor/context_evaluator'
    def evaluate_in_context(context, expr)
      ContextEvaluator.new(context).evaluate(expr)
    end

    def subprocess_node(context, node, list)
      processor = Thymeleaf::TemplateEngine.new
      processor.send(:process_node, context, node, list)
    end

    def load_template(template_name)
      template_uri = Thymeleaf.configuration.template_uri(template_name)
      File.open template_uri do |template_file|
        template_file.rewind
        yield template_file.read
      end
    end
  end
  # NullProcessor class definition
  class NullProcessor
    def call(node: nil, buffer: nil, **_)
      if !node.marked?
        node.mark
        NodeWriter.write_head_buffer(buffer, node)
        # NodeWriter.write_empty_line_buffer(buffer)
      end 
    end
  end
end
