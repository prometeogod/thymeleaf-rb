class Instructions
  attr_accessor :tag_instructions, :attribute_instructions, :especial_instructions
  
  def initialize(tag_instructions = [], attribute_instructions = [], especial_instructions = [])
    @tag_instructions = tag_instructions
    @attribute_instructions = attribute_instructions
    @especial_instructions = especial_instructions
  end

  def empty?
    tag_instructions.empty? && attribute_instructions.empty? && especial_instructions.empty?
  end

  def to_buffer_begin(buffer)
  	to_buffer_begin_especial_instructions(buffer)
    to_buffer_begin_attribute_instructions(buffer)
    to_buffer_begin_tag_instructions(buffer)
  end

  def to_buffer_end(buffer)
    to_buffer_end_tag_instructions(buffer)
    to_buffer_end_attribute_instructions(buffer)
    to_buffer_end_especial_instructions(buffer)
  end 

  private 
  
  # REGULAR_EXP = /to_buffer_(begin|end)_(\w*)/
  
  def to_buffer_begin_attribute_instructions(buffer)
    attribute_instructions.each do |attribute_instruction|
      buffer << attribute_instruction.begin_instruction
    end
  end

  def to_buffer_end_attribute_instructions(buffer)
    attribute_instructions.each do |attribute_instruction|
      buffer << attribute_instruction.end_instruction
    end
  end

  def to_buffer_begin_tag_instructions(buffer)
    tag_instructions.each do |tag_instruction|
      buffer << tag_instruction.begin_instruction
    end
  end

  def to_buffer_end_tag_instructions(buffer)
    tag_instructions.each do |tag_instruction|
      buffer << tag_instruction.end_instruction
    end
  end

  def to_buffer_begin_especial_instructions(buffer)
    especial_instructions.each do |especial_instruction|
      buffer << especial_instruction.begin_instruction
    end
  end

  def to_buffer_end_especial_instructions(buffer)
    especial_instructions.each do |especial_instruction|
      buffer << especial_instruction.end_instruction
    end 
  end

end