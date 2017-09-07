def to_cache_name(filename,suffix=nil)
  cache_name=filename.gsub!(/[\/.]/, '_')
  if (suffix!=nil)
    cache_name+=suffix
  end
  cache_name
end

def to_file_name(cache_name,suffix=nil)
  if (suffix!=nil)
  	cache_name_array=cache_name.split(suffix)
  end
  filename=cache_name_array[0]
  list= filename.rpartition("th")
  filename_head=list[0].chop.gsub!(/[_]/,'/')
  filename_tail='.'+list[1]+list[2].gsub!(/[_]/,'.')
  filename=filename_head+filename_tail
end