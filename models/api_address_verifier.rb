# require "easypost"
EasyPost.api_key = "cueqNZUb3ldeWTNX7MU3Mel8UXtaAMUi"

class ApiAddressVerifier

	def initialize
	end

	@@instance = ApiAddressVerifier.new

	def self.instance
		@@instance
	end

	def verify_with_easypost(addr)
		parsed = parse_address_for_easypost(addr)
		easypost_addr = EasyPost::Address.create(parsed)
		begin
			easypost_addr.verify
		rescue => e
			{error: e.message[0..34]}
		end
	end

	def create_easypost_call(addr)
		parse_address_for_easypost(addr)
		lambda { EasyPost::Address.verify(addr) }
	end

	def parse_address_for_easypost(addr)
		addr.delete_if {|key,val| !val}

		addr[:zip]		 = addr[:postal_code]
		addr[:street1] = addr[:line1]

		addr
	end

end
