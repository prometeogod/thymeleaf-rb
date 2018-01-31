class Writer
  def initialize
    @buffer = []
  end

  def write(x)
    @buffer << x
  end
    
  def <<(x)
    @buffer << x
  end
	
  def output
    @buffer.join
  end
end
