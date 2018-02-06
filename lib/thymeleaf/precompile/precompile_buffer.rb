class PrecompileBuffer
  def initialize
    @buffer = []
  end

  def write(string)
    buffer << "#{string}\n"
  end

  def flush
  	buffer.join
  end

  private

  attr_accessor :buffer
end
