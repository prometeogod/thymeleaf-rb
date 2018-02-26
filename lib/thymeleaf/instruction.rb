class Instruction
  attr_accessor :begin_instruction, :end_instruction
  def initialize(begin_instruction =  nil, end_instruction = nil)
    @begin_instruction = begin_instruction
    @end_instruction = end_instruction
  end

  def empty?
    return true if (begin_instruction.nil? && end_instruction.nil?)
    false
  end

  def join(separator = '')
    array = []
    array << begin_instruction unless begin_instruction.nil?
    array << end_instruction unless end_instruction.nil?
    array.join(separator)
  end
end