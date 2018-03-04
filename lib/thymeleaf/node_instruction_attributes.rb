class NodeInstructionAttributes
  attr_accessor :simple_attributes, :from_default
  def initialize(simple_attributes = {}, from_default = {})
    @simple_attributes = simple_attributes
    @from_default = from_default
  end

  def empty?
    return true if simple_attributes.empty? && from_default.empty?
    false
  end
end