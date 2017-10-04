require_relative './../nodetree'

class JSONToNodetreeConverter
 
	def to_nodetree(list_json)
		nodetree_list= []
		list_json.each do |node_json|
		   nodetree_list << to_nodetree_json_node(node_json)
		end
		nodetree_list
	end

	private
	
	def to_nodetree_json_node(node_json, parent=nil)
	   
	   name= node_json['name']
	   attributes=node_json['attributes']
	   
	   node = NodeTree.new(name,attributes)
	   
	   children=[]
	   node_json['children'].each do |child|
	     children<<to_nodetree_json_node(child,node)
	   end
	   node.children=children
	   
	   node.parent=parent
	   node
	end 

end