class Formatter
  #def select_html_attributes(attributes)
  #  attributes.select{|key,value| !key.match(PATTERN)}
  #end
 
  #def select_th_attributes(attributes)
  #  attributes.select{|key,value| key.match(PATTERN)}
  #end

  def attributes_string(attributes)
    string = ''
    attributes.each{|key,value| string += (" #{key.to_s}=\"#{value}\"")}
    string
  end

  # def to_string_regular_attributes(html_attributes)
  #  string = ''
  #  html_attributes.each do |k,v|
  #    if k.match(/data-th-^*/)
  #      new_k = k.gsub(/data-th-/,'')
  #      string += (' ' + new_k.to_s + '=' + '"' + v + '"')
  #    else
  #      string += (' ' + k.to_s + '=' + '"' + v + '"')	
  #    end 
  #  end
  #  string
  # end

  #def length_th(attributes)
  #  select_th_attributes(attributes).length
  #end
  
  #private 
  
  #PATTERN = /data-th-(if|unless|text|utext|switch|case|object|each)/
end
