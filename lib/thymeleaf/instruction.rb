class Instruction
  attr_reader :begin_instruction, :end_instruction
  
  def initialize(begin_instruction =  nil, end_instruction = nil)
    @begin_instruction = begin_instruction
    @end_instruction = end_instruction
  end

  def empty?
    begin_instruction.nil? && end_instruction.nil?
  end

  def to_a
    [begin_instruction, end_instruction]
  end

  def join(separator = '')
    [begin_instruction, end_instruction].compact.join(separator)
  end
end