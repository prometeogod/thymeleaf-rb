def to_cache_name(filename, suffix = nil)
  cache_name = filename.gsub(%r{[\/.]}, '_')
  cache_name += suffix unless suffix.nil?
  cache_name
end

def to_file_name(cache_name, suffix = nil)
  cache_name_array = cache_name.split(suffix) unless suffix.nil?
  filename = cache_name_array[0]
  list = filename.rpartition('th')
  filename_head = list[0].chop.gsub(/[_]/, '/')
  filename_tail = '.' + list[1] + list[2].gsub(/[_]/, '.')
  filename_head + filename_tail
end
