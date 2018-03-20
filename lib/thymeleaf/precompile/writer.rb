class Writer
  def initialize
    @buffer = []
  end

  def write(x)
    buffer << x
  end
	
  def output
    buffer.join
  end
  
  private 

  attr_accessor :buffer
end
