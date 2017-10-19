require_relative './../nodetree'
# JSONToNodetreeConverter : Converts a list of json nodes
# into a list of NodeTree
class JSONToNodetreeConverter
  def to_nodetree(list_json)
    list_json.map { |node_json| to_nodetree_json_node(node_json) }
  end

  private

  def to_nodetree_json_node(node_json, parent = nil)
    name = node_json['name']
    attributes = node_json['attributes']

    node = NodeTree.new(name, attributes)

    children = node_json['children'].map do |child|
      to_nodetree_json_node(child, node)
    end
    node.children = children

    node.parent = parent
    node
  end
end
