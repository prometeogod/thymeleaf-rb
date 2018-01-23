PATTERN = /data-th-(if|unless|text|utext|switch|case|object)/

def select_regular(hash)
  hash.select{|k,v| !k.match(PATTERN)}
end

def select_th_attributes(hash)
  hash.select{|k,v| k.match(PATTERN)}
end

def to_string_attributes(hash)
  string = ''
  hash.each{|k,v| string += (' ' + k.to_s + '=' + '"' + v + '"')}
  string
end

def to_string_regular_attributes(hash_regulars)
  string = ''
  hash_regulars.each do |k,v|
    if k.match(/data-th-^*/)
      new_k = k.gsub(/data-th-/,'')
      string += (' ' + new_k.to_s + '=' + '"' + v + '"')
    else
      string += (' ' + k.to_s + '=' + '"' + v + '"')	
    end 
  end
  string
end

def length_th(attributes)
  length = 0
  attributes.each do |k,v|
    if k.match(PATTERN)
      length += 1
    end
  end
  length
end
