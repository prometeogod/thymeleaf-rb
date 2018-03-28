def convert_to_instructions(statement_list)
  instructions = []
  statement_list.each do |statement|
    if statement.is_a?(Array)
      instructions << Instruction.new(statement[0],statement[1])
    else
      instructions << Instruction.new(statement)
    end
  end
  instructions
end