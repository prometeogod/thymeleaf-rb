class Cache

	attr_accessor :count, :limit

	Node = Struct.new(:key ,:value)

	def initialize(limit=nil)
	  @data = {}
	  @count = 0
	  self.limit=limit if limit
	  
	end

	# Delete the element with that key in the Cache and return the value or nil if not exists
	def delete(key)
	  node = @data.delete(key)
	  return unless node
	  self.count -= 1
	  node.value		
	end
	# Clear the Cache , delete all elements
	def clear
	  @data.clear
	  self.count = 0
	end

	# Return the value with that key or nil if not exists
	def get(key)
	  node = @data[key]
	  if node
	  	node.value
	  end
	end

	# Sets the value to the element with that key or creates a new pair
	def set(key,value)
	  node = @data[key]
	  unless node
	  	node = Node.new(key)
	  	@data[key]=node
	  	self.count += 1
	  end
	  node.value = value
	end

	# Returns an array with each element as an array of pair key-value
	def to_a
	  array = @data.to_a
	  array.reverse!
	end

	# Returns de key elements in an array
	def keys
	  @data.keys
	end

	def data
	  @data
	end
end
