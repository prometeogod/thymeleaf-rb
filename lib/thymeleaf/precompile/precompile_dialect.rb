require_relative '../dialects/dialect'
class PrecompileDialect < Dialect
  CONTEXT_SWITCH_VAR   = 'switch_var'.freeze
  CONTEXT_FRAGMENT_VAR = 'fragment_var'.freeze
  CONTEXT_OBJECT_VAR   = 'context_obj'.freeze

  def self.default_key
    'th'
  end

  def self.context_fragment_var(var_name)
    "#{CONTEXT_FRAGMENT_VAR}_#{var_name}"
  end

  def tag_processors
    {
      block: BlockPreprocessor
    }
  end

  # Precedence based on order for the time being
  def processors
    {
      #insert:   InsertProcessor,
      #replace:  ReplaceProcessor,
      #fragment: FragmentProcessor,
      #each:     EachProcessor,
      if:       IfPreprocessor,
      unless:   UnlessPreprocessor,
      switch:   SwitchPreprocessor,
      case:     CasePreprocessor,
      object:   ObjectPreprocessor, # TODO in progress
      text:     TextPreprocessor,
      utext:    UTextPreprocessor,
      #remove:   RemoveProcessor,
      default:  DefaultPreprocessor
    }
  end

  require_relative 'precompile_processors/if_preprocessor'
  require_relative 'precompile_processors/text_preprocessor'
  require_relative 'precompile_processors/utext_preprocessor'
  require_relative 'precompile_processors/unless_preprocessor'
  require_relative 'precompile_processors/case_preprocessor'
  require_relative 'precompile_processors/switch_preprocessor'
  require_relative 'precompile_processors/block_preprocessor'
  require_relative 'precompile_processors/default_preprocessor'
  require_relative 'precompile_processors/object_preprocessor'
end