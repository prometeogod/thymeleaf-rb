# Module Thymeleaf definition
module Thymeleaf
  # Module Processor definition
  module Processor
    require_relative 'processor/context_evaluator'
    def evaluate_in_context(context, expr)
      ContextEvaluator.new(context).evaluate(expr)
    end
    
    def subprocess_node(node, node_instruction, parent_instruction, buffer_writer)
      parent_instruction.add_child(node_instruction)
      precompiler = Precompiler.new
      precompiler.send(:process_node, node, node_instruction, parent_instruction, buffer_writer)  
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
    def call(**_)
    end
  end
end
