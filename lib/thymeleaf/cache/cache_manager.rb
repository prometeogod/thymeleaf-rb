require_relative '../nodetree'
require_relative 'cache'
class CacheManager
  
  attr_accessor :parsed_cache

  def initialize
  end

  def create_parsed_cache
  	self.parsed_cache = Cache.new
  	mem2parsed_cache("lib/thymeleaf/cache/parsed_cache",self.parsed_cache)
  end
  # Read memory and creates a parsed templates cache
  def mem2parsed_cache(folder, cache)
  	Dir.foreach(folder) do |file| 
	  if (file != ".") && (file != "..")
		array=read_from_file(folder+"/"+file)
		node_list=to_nodetree_list(array)
		cache.set(file,node_list)
	  end
	end
  end

  
  def write_file_cache(node_list,filename)
    file_suffix = '.th.parsed_cache'
    file = filename+file_suffix
    File.open(file,'w+') do |file|
  	  node_list.each do |node|
  	    string_cache=node.to_string_cache
  	    string_cache.each do |string|
  	      file.puts string
  	    end
  	    file.puts '****'	  
  	  end
    end	  
  end

  # Reads a file and creates an indexed array with this format : index;name;attributes;parent_index
  def read_from_file(filename)
    file_suffix = '.th.parsed_cache'
    array=[]
    i=0
    array[i]=[]
    File.open(filename,'r') do |file|
  	  while linea = file.gets
  	  	if linea.to_s == "****\n"
  	  		i+=1
  	  		array[i]=[]
  	    else
  	      array[i] << linea
  	    end
  	  end
    end
    array.delete(array.last)
    j=0
    while j < array.length
      i=0
      array_cache = array[j]
      while i < array_cache.length
  	    if array_cache[i].split(';').length == 2
          array_cache[i-1] << "\r"<< array_cache[i]
          array_cache.delete_at(i)
 	    else
 	      i+=1
 	    end
      end
      j+=1
    end
    array
  end

  # Returns a list of Nodetree from an array
  def to_nodetree_list(array)
  	list = []
  	array.each do |array_cache|
  	  list << to_nodetree_cache(array_cache)
  	end
  	list
  end

  private
  
  # Returns a Nodetree from an array cache
  def to_nodetree_cache(array_cache)
    root_node=array_cache[0].split(';')
    if root_node[1] == 'text-content'
  	  root_attributes = root_node[2]
    else
  	  root_attributes = to_attributes(root_node[2])
    end
    root = NodeTree.new(root_node[1],root_attributes)
    dic ={ root_node[0].to_i => root }
    array_cache.each do |string|
  	  node = string.split(';')
  	  if node[3].to_i != 0
  	    parent = dic[node[3].to_i]
  	    if node[1] == 'text-content'
  	      attributes = node[2]
  	    else
  	  	  attributes = to_attributes(node[2])
  	    end
  	    nodetree = NodeTree.new(node[1],attributes)
  	    parent.add_child(nodetree)
  	    dic[node[0].to_i]=nodetree
  	  end
    end
    dic.clear
    root
  end

 
  
  # Returns attributes from a string. To nodes non text-content
  def to_attributes(attributes_string)
	attributes={}
	array_attributes = attributes_string.split(',')
	array_attributes.each do |string|
	  pair = string.split('=')
	  value = pair[1]
	  value = value[1,value.length-2] 
	  attributes.store(pair[0],value)
	 end
	attributes
  end


end