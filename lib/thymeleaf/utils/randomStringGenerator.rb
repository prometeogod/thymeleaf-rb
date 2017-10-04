require 'digest'
class RandomStringGenerator
	attr_accessor :random
	def initialize
		self.random=Digest::SHA512.hexdigest Random.rand.to_s
	end

end