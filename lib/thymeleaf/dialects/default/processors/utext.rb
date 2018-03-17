require_relative '../../../precompile/buffer_writer'
# UTextProcessor
class UTextProcessor
  def call(node: nil, node_instruction: nil, parent_instruction: nil, buffer_writer: nil, attribute: nil, key: nil)
    instruction = buffer_writer.write "EvalExpression.parse(context,\'#{attribute}\')"   
    text_node = NodeInstruction.new
    text_node.nodetree = node
    text_node.instructions.especial_instructions << Instruction.new(instruction)
    node_instruction.add_child(text_node)
    node.children.clear
    node.attributes.delete('data-th-utext')
  end
end