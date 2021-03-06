require_relative '../../processor'
require_relative '../dialect'
class DefaultDialect < Dialect
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
      block: BlockProcessor
    }
  end

  # Precedence based on order for the time being
  def processors
    {
      insert:   InsertProcessor,
      replace:  ReplaceProcessor,
      fragment: FragmentProcessor,
      each:     EachProcessor,
      if:       IfProcessor,
      unless:   UnlessProcessor,
      switch:   SwitchProcessor,
      case:     CaseProcessor,
      object:   ObjectProcessor, 
      text:     TextProcessor,
      utext:    UTextProcessor,
      remove:   RemoveProcessor,
      default:  DefaultProcessor
    }
  end

  def html_processors
    {
      meta: MetaProcessor,
      comment: CommentProcessor,
      doctype: DoctypeProcessor,
      text_content: TextContentProcessor,
      root: RootProcessor
    }
  end

  require_relative 'parsers/eval'
  require_relative 'parsers/selection'
  require_relative 'parsers/each'
  require_relative 'parsers/fragment'

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
  require_relative 'processors/meta'
  require_relative 'processors/text_content'
  require_relative 'processors/comment'
  require_relative 'processors/doctype'
  require_relative 'processors/root'
end