require_relative '../nodetree'
require_relative 'cache'
require_relative 'nodeValueDate'
require_relative '../utils/jsonToNodetreeConverter'
require 'json'
require 'time'
class CacheManager
  
  attr_accessor :parsed_cache , :fragment_cache

  def clear_caches
    folder='lib/thymeleaf/cache/parsed_cache/'
    Dir.foreach(folder) do |file|
      if (file != ".")&& (file != "..")
        File.delete(folder+file)
      end
    end
    folder='lib/thymeleaf/cache/fragment_cache/'
    Dir.foreach(folder) do |file|
      if (file != ".")&& (file != "..")
        File.delete(folder+file)
      end
    end
  end
  

  def create_parsed_cache
  	self.parsed_cache = Cache.new
  	mem2parsed_cache("lib/thymeleaf/cache/parsed_cache",self.parsed_cache)
  end

  def create_fragment_cache
    self.fragment_cache = Cache.new
    mem2fragment_cache("lib/thymeleaf/cache/fragment_cache",self.fragment_cache)
  end
  # Read memory and creates a parsed templates cache
  def mem2parsed_cache(folder, cache)
    Dir.mkdir(folder, 0700)  if !Dir.exist?(folder)
  	Dir.foreach(folder) do |file| 
	    if (file != ".") && (file != "..")
		    time,nodetree_list=read_file_cache(folder+"/"+file)
        nodevd=NodeValueDate.new(nodetree_list,time)
		    cache.set(file,nodevd)
	    end
	  end
  end

  def mem2fragment_cache(folder,cache)
    Dir.mkdir(folder, 0700)  if !Dir.exist?(folder)
    Dir.foreach(folder) do |file|
      if (file != ".")&& (file != "..")
        key, nodetree_list = read_file_fragment(folder+"/"+file)
        cache.set(key,nodetree_list.first)
      end
    end
  end

  def write_file_cache(node_list,filename)
    file_suffix = '.th.parsed_cache'
    file_preffix = 'lib/thymeleaf/cache/parsed_cache/'
    file = file_preffix+filename+file_suffix
    list=[]
    node_list.each { |node| list << node.to_h }     
    hash={
      :time => Time.now,
      :value => list
    }
    json=hash.to_json
    File.open(file,'w+') do |file|
      file.puts json
    end 
  end

  def read_file_cache(filename)
    hash=read_file_json(filename)

    nodes= hash['value']
    time = Time.parse(hash['time']) # Unica linea que cambia

    nodetree_list=JSONToNodetreeConverter.new.to_nodetree(nodes)
    [time,nodetree_list]
  end

  def write_file_fragment(node,key,filename)
    file_suffix = '.th.fragment_cache'
    file_preffix = 'lib/thymeleaf/cache/fragment_cache/'
    file = file_preffix+filename+file_suffix
    list=[] << node.to_h
    hash={
      :key => key,
      :value => list
    }
    json=hash.to_json
    File.open(file,'w+') do |file|
      file.puts json
    end 
  end

  def read_file_fragment(filename)
    hash=read_file_json(filename)
    
    nodes= hash['value']
    key = hash['key'] # Unica linea que cambia
    
    nodetree_list=JSONToNodetreeConverter.new.to_nodetree(nodes)
    [key,nodetree_list]
  end
  
  private

  def read_file_json(filename)
    json=""
    File.open(filename,'r') do |file|
      while linea = file.gets
        json << linea
      end
    end
    hash=JSON.parse(json)
    
  end
end