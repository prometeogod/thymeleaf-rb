require_relative '../dialect'

class DefaultDialectSax < Dialect
  
  CONTEXT_SWITCH_VAR   = 'switch_var'
  CONTEXT_FRAGMENT_VAR = 'fragment_var'
  CONTEXT_OBJECT_VAR   = 'context_obj'

  def self.default_key
    'th'
  end
  
  def self.context_fragment_var(var_name)
    "#{CONTEXT_FRAGMENT_VAR}_#{var_name}"
  end
  
  def tag_processors
    {
        block: BlockProcessorSax
    }
  end

  # Precedence based on order for the time being
  def processors
    {
        insert:   InsertProcessorSax,
        replace:  ReplaceProcessorSax,
        fragment: FragmentProcessorSax,
        each:     EachProcessorSax,
        if:       IfProcessorSax,
        unless:   UnlessProcessorSax,
        switch:   SwitchProcessorSax,
        case:     CaseProcessorSax,
        object:   ObjectProcessorSax,
        text:     TextProcessorSax,
        utext:    UTextProcessorSax,
        remove:   RemoveProcessorSax,
        default:  DefaultProcessorSax
    }
  end

  require_relative 'parsers/eval'
  require_relative 'parsers/selection'
  require_relative 'parsers/each'
  require_relative 'parsers/fragment'

  require_relative 'processors-sax/default'
  require_relative 'processors-sax/object'
  require_relative 'processors-sax/text'
  require_relative 'processors-sax/utext'
  require_relative 'processors-sax/if'
  require_relative 'processors-sax/unless'
  require_relative 'processors-sax/switch'
  require_relative 'processors-sax/case'
  require_relative 'processors-sax/each'
  require_relative 'processors-sax/remove'
  require_relative 'processors-sax/insert'
  require_relative 'processors-sax/replace'
  require_relative 'processors-sax/block'
  require_relative 'processors-sax/fragment'

end