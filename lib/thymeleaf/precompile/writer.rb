class Writer
	def initialize(output)
	  @buffer = []
	  @output = output
	end

    def write(x)
       @buffer << x
    end
    
	def <<(x)
		@buffer << x
	end

	def flush
		@output.call(@buffer.join())
		@buffer = []
	end
	def output
	end
end

class StringWriter < Writer
    def initialize
      super(nil)
    end

	def flush
	end

	def output
		@buffer.join
	end
end