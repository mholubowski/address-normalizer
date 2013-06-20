##################################################
# Takes a string address, returns tokenized
##################################################
require 'street_address'

class TokenizedAddress
	attr_reader :address, :number, :street, :street_type, 
							:unit, :unit_prefix, :suffix, :prefix, :city, 
							:state, :postal_code, :postal_code_ext

	def initialize string, options = {informal: false}
		obj = StreetAddress::US.parse(string, options)
		return if obj.nil?
		
		@address 					= obj.to_s
		@number  					= obj.number 
		@street  					= obj.street
		@street_type 			= obj.street_type
		@unit 			 			= obj.unit
		@unit_prefix 			= obj.unit_prefix
		@suffix 					= obj.suffix
		@prefix 					= obj.prefix
		@city   					= obj.city
		@state  					= obj.state
		@postal_code 			= obj.postal_code
		@postal_code_ext  = obj.postal_code_ext
	end

end
