require_relative '../dialect'
class PrecompileDialect < Dialect
  CONTEXT_SWITCH_VAR   = 'switch_var'.freeze
  CONTEXT_FRAGMENT_VAR = 'fragment_var'.freeze
  CONTEXT_OBJECT_VAR   = 'context_obj'.freeze
  EACH_ELEMENT = 'each_element'.freeze

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
      insert:   InsertPreprocessor,
      replace:  ReplacePreprocessor,
      fragment: FragmentPreprocessor,
      each:     EachPreprocessor,
      if:       IfPreprocessor,
      unless:   UnlessPreprocessor,
      switch:   SwitchPreprocessor,
      case:     CasePreprocessor,
      object:   ObjectPreprocessor, 
      text:     TextPreprocessor,
      utext:    UTextPreprocessor,
      remove:   RemovePreprocessor,
      default:  DefaultPreprocessor
    }
  end

  require_relative 'processors/if'
  require_relative 'processors/text'
  require_relative 'processors/utext'
  require_relative 'processors/unless'
  require_relative 'processors/case'
  require_relative 'processors/switch'
  require_relative 'processors/block'
  require_relative 'processors/default'
  require_relative 'processors/object'
  require_relative 'processors/each'
  require_relative 'processors/fragment'
  require_relative 'processors/remove'
  require_relative 'processors/insert'
  require_relative 'processors/replace'
end