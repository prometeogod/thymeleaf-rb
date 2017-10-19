# NodeValueDate definition : node that holds a value and a date
class NodeValueDate
  attr_accessor :value, :date

  def initialize(value, date = nil)
    self.value = value
    self.date = Time.now
    self.date = date unless date.nil?
  end
end
