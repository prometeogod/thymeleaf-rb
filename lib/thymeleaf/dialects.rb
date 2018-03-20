# Thymeleaf module
require_relative 'dialects/default/processors/null'
module Thymeleaf
  # Dialects class definition
  class Dialects
    def initialize
      clear_dialects
    end

    def add_dialect(*args)
      key, dialect_class = * expand_key_dialect(*args)

      dialect = dialect_class.new

      registered_dialects[key] = dialect
      registered_attr_processors[key] = dialect_processors(dialect)
      registered_tag_processors[key] = dialect_tag_processors(dialect)
      registered_html_processors[key] = dialect_html_processors(dialect)
    end

    def clear_dialects
      self.registered_dialects        = {}
      self.registered_attr_processors = {}
      self.registered_tag_processors  = {}
      self.registered_html_processors = {}
    end

    def find_attr_processor(key)
      find_processor key, dialect_attr_matchers, registered_attr_processors
    end

    def find_tag_processor(key)
      find_processor key, dialect_tag_matchers, registered_tag_processors
    end

    def find_html_processor(key)
      find_processor_html key, dialect_html_matchers, registered_html_processors
    end

    private

    attr_accessor :registered_dialects, :registered_attr_processors
    attr_accessor :registered_tag_processors, :registered_html_processors

    def dialect_attr_matchers
      /^data-(#{registered_dialects.keys.join("|")})-(.*)$/
    end

    def dialect_tag_matchers
      /^(#{registered_dialects.keys.join("|")})-(.*)$/
    end

    def dialect_html_matchers
      /^(meta|doctype|text_content|comment|root)/
    end

    def null_processor
      #@null_processor ||= NullProcessor.new
      @null_processor ||= NullProcessor.new
    end

    def expand_key_dialect(*args)
      if args.length == 1
        [args[0].default_key, args[0]]
      elsif args.length == 2
        args
      else
        raise ArgumentError
      end
    end

    def dialect_processors(dialect)
      dialect.processors.reduce({}) do |processors, (processor_key, processor)|
        processors[processor_key.to_s] = processor.new
        processors
      end
    end

    def dialect_tag_processors(dialect)
      dialect.tag_processors.reduce({}) do |processors, (processor_key, processor)|
        processors[processor_key.to_s] = processor.new
        processors
      end
    end

    def dialect_html_processors(dialect)
      dialect.html_processors.reduce({}) do |processors, (processor_key, processor)|
        processors[processor_key.to_s] = processor.new 
        processors
      end
    end
    
    def find_processor_html(key, dialect_matchers, processor_list)
      unless dialect_matchers.match(key).nil?
        dialect_key = 'th'
        dialect_processors = processor_list[dialect_key]
        raise ArgumentError, "No dialect found for key #{key}" if dialect_processors.nil?

        processor = dialect_processors[key]
        raise ArgumentError, "No processor found for key #{key}" if processor.nil?
        [key, processor]
      end
    end

    def find_processor(key, dialect_matchers, processor_list)
      match = dialect_matchers.match(key)
      # TODO: check performance null object vs null check
      return [key, null_processor] if match.nil?

      dialect_key, processor_key = *match[1..2]

      dialect_processors = processor_list[dialect_key]
      raise ArgumentError, "No dialect found for key #{key}" if dialect_processors.nil?

      processor = dialect_processors[processor_key] || dialect_processors['default']
      raise ArgumentError, "No processor found for key #{key}" if processor.nil?

      [processor_key, processor]
    end
  end
end
