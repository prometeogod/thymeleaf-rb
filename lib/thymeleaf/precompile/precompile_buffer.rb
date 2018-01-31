class PrecompileBuffer
  attr_accessor :buffer

  def initialize
    self.buffer = []
  end

  def write(string)
    self.buffer << "#{string}\n"
  end

  def flush
  	buffer.join
  end
end
