class Store
  attr_accessor :diccionary
  def initialize
  	self.diccionary = {}
  end
  
  def get(key)    
    diccionary[key]
  end

  def set(key, value)
    diccionary[key]=value
  end

  def set?(key)
    diccionary.include?(key)
  end
  
  def unset(key)
    diccionary.delete(key)
  end

  def count
    diccionary.size
  end

  def reset
    diccionary.clear
  end
 
  def empty?
    diccionary.empty?
  end
end