class PrecompileBuffer
  def initialize
    @buffer = []
  end

  def write(string)
    buffer << "#{string}\n"
  end

  def <<(string)
    buffer << "#{string}\n"
  end

  def flush
  	buffer.join
  end

  def length
    buffer.length
  end
   
  def empty?
    buffer.empty?
  end

  private

  attr_accessor :buffer
end
