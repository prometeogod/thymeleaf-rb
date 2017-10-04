class NodeValueDate
  attr_accessor :value, :date 

  def initialize(value,date=nil)
  	self.value = value
  	if (date != nil)
 	  self.date = date
 	else
 	  self.date = Time.now
 	end
  end
end