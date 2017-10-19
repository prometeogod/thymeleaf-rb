# TemplaateResolver class definition
class TemplateResolver
  attr_accessor :prefix, :suffix

  def initialize
    self.prefix = ''
    self.suffix = ''
  end

  def get_template(template_name)
    "#{prefix}#{template_name}#{suffix}"
  end
end
