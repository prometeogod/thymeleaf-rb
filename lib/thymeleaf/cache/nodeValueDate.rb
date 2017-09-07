class NodeValueDate
  attr_accessor :value, :date 

  def initialize(value,date=nil)
  	@value = value
  	if (date != nil)
 	  @date = date
 	else
 	  @date = Time.now
 	end
  end
end