require_relative 'cache'
require_relative '../dialects/default/default_dialect'
class ProcessorCache
	attr_accessor :dialects , :processors , :tag_processors

	def initialize
	  insert_processors
	end

	private
	def insert_processors
		@dialects=  Cache.new
		default_dialect_key = DefaultDialect.default_key
		default_dialect = DefaultDialect.new
		@dialects.set(default_dialect_key,default_dialect)

		processors_details = Cache.new
		default_dialect.processors.each do |key , value|
		  processors_details.set(key.to_s,value.new)
		end
		@processors = Cache.new
		@processors.set(default_dialect_key,processors_details)

		tag_processors_details = Cache.new
		default_dialect.tag_processors.each do |key , value|
		  tag_processors_details.set(key.to_s,value.new)
		end
		@tag_processors = Cache.new
		@tag_processors.set(default_dialect_key,tag_processors_details)
	end
end