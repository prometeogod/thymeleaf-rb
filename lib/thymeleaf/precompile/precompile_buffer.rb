class PrecompileBuffer
  attr_accessor :buffer

  def initialize
    self.buffer = []
  end

  def write(string)
    self.buffer << string
  end

  def flush
  	buffer.join
  end
end
