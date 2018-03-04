class Formatter
  def attributes_string(attributes)
    string = ''
    attributes.each{|key,value| string += (" #{key.to_s}=\"#{value}\"")}
    string
  end

  def init_stat_var(stat, elements)
    if stat.nil?
      nil
    else
      {
        index: -1,
        count: 0,
        size: elements.length,
        current: nil,
        even: false,
        odd: true,
        first: true,
        last: false
      }
    end
  end
end
