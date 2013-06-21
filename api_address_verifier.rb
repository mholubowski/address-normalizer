require "easypost"
EasyPost.api_key = "cueqNZUb3ldeWTNX7MU3Mel8UXtaAMUi"

class ApiAddressVerifier

	def initialize
		
	end

	def create_easypost_call(addr)
		parse_address_for_easypost(addr)
		lambda { EasyPost::Address.verify(addr) }
	end

	def parse_address_for_easypost(addr)
		addr.delete_if {|key,val| !val}

		addr[:zip]		 = addr[:postal_code]
		addr[:street1] = "#{addr[:number]} #{addr[:street]} #{addr[:street_type]}"
	end

end