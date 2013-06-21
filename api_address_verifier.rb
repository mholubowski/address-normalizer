require "easypost"

class ApiAddressVerifier

	def initialize
		
	end

	def create_easy_post_call(address_hash)
		lambda { EasyPost::Address.verify(address_hash) }
	end

end