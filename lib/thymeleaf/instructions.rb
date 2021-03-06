class Instructions
  attr_accessor :tag_instructions, :attribute_instructions, :especial_instructions, :before_children
  
  def initialize(tag_instructions = [], attribute_instructions = [], especial_instructions = [], before_children = [])
    @tag_instructions = tag_instructions
    @attribute_instructions = attribute_instructions
    @especial_instructions = especial_instructions
    @before_children = before_children
  end

  def empty?
    tag_instructions.empty? && attribute_instructions.empty? && especial_instructions.empty?
  end

  def first_instruction
    return especial_instructions[0] unless especial_instructions.empty?
    return attribute_instructions[0] unless attribute_instructions.empty?
    return tag_instructions[0] unless tag_instructions.empty?
    return before_children[0] unless before_children.empty?
  end

  def to_buffer_begin(buffer)
  	to_buffer_begin_especial_instructions(buffer)
    to_buffer_begin_attribute_instructions(buffer)
    to_buffer_begin_tag_instructions(buffer)
  end

  def to_buffer_before_children(buffer)
    to_buffer_begin_before_children(buffer)
    to_buffer_end_before_children(buffer)
  end

  def to_buffer_end(buffer)
    to_buffer_end_tag_instructions(buffer)
    to_buffer_end_attribute_instructions(buffer)
    to_buffer_end_especial_instructions(buffer)
  end 

  private

  def to_buffer_begin_before_children(buffer)
    before_children.each do |instruction|
      buffer << instruction.begin_instruction unless instruction.begin_instruction.nil?
    end
  end

  def to_buffer_end_before_children(buffer)
    before_children.reverse.each do |instruction|
      buffer << instruction.end_instruction unless instruction.end_instruction.nil? 
    end
  end
  
  def to_buffer_begin_attribute_instructions(buffer)
    attribute_instructions.each do |attribute_instruction|
      buffer << attribute_instruction.begin_instruction unless attribute_instruction.begin_instruction.nil?
    end
  end

  def to_buffer_end_attribute_instructions(buffer)
    attribute_instructions.each do |attribute_instruction|
      buffer << attribute_instruction.end_instruction unless attribute_instruction.end_instruction.nil?
    end
  end

  def to_buffer_begin_tag_instructions(buffer)
    tag_instructions.each do |tag_instruction|
      buffer << tag_instruction.begin_instruction unless tag_instruction.begin_instruction.nil?
    end
  end

  def to_buffer_end_tag_instructions(buffer)
    tag_instructions.each do |tag_instruction|
      buffer << tag_instruction.end_instruction unless tag_instruction.end_instruction.nil?
    end
  end

  def to_buffer_begin_especial_instructions(buffer)
    especial_instructions.each do |especial_instruction|
      buffer << especial_instruction.begin_instruction unless especial_instruction.begin_instruction.nil?
    end
  end

  def to_buffer_end_especial_instructions(buffer)
    especial_instructions.each do |especial_instruction|
      buffer << especial_instruction.end_instruction unless especial_instruction.end_instruction.nil?
    end 
  end

end
