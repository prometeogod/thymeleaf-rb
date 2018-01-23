class Evaluation
  def self.evalue(expr)
    if expr.match(/(\${.+?})/)
      out = expr[2..-2]
      [true, out]
    else
      [nil, expr]
    end
  end

  def self.asterisk_object(expr, object)
    splitted_expr = expr.split
    string = ''
    splitted_expr.each do |substring|
      if substring.match(/(\*{.+?})/)
        out = substring[2..-2]
        string+=' (expresion.call('+object+','+'"'+out+'"'+').to_s)'
        if splitted_expr.index(substring) < splitted_expr.length-1
          string+= ' '+ '+'+'" "'+'+'
        end
      else
        string+=' "'+substring+'"' 
        if splitted_expr.index(substring) < splitted_expr.length-1
          string+=  ' '+ '+'+'" "'+'+'
        end
      end
    end
    string
  end
end
