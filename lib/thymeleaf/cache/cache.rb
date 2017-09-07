class Cache

	attr_reader :count, :limit

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
	  @count -= 1
	  node.value		
	end
	# Clear the Cache , delete all elements
	def clear
	  @data.clear
	  @count = 0
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
	  	@count += 1
	  end
	  node.value = value
	end

	# Returns an array with each element as an array of pair key-value
	def to_a
	  array = @data.to_a
	  array.reverse!
	end

	# Sets the value of the limit
	def limit=(new_limit)
		@limit = new_limit
	end

	# Returns de key elements in an array
	def keys
	  @data.keys
	end

	def data
	  @data
	end
end
