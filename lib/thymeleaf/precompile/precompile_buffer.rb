class PrecompileBuffer
  attr_accessor :buffer

  def initialize
    self.buffer = []
  end

  def write(string)
    self.buffer << string
  end

  def to_html
  	string = ''
    buffer.each do |line|
      string += line
    end
    string
  end

  def to_file(file)

  end
end
