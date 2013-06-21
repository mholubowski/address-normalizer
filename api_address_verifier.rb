require "easypost"
EasyPost.api_key = "cueqNZUb3ldeWTNX7MU3Mel8UXtaAMUi"

class ApiAddressVerifier

	def initialize
		
	end

	def create_easypost_call(address_hash)
		parse_address_for_easypost(address_hash)
		lambda { EasyPost::Address.verify(address_hash) }
	end

	def parse_address_for_easypost(address_hash)
		address_hash.delete_if {|key,val| !val}
	end

end