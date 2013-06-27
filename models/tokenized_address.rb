require 'street_address'
require_relative 'address_set'

class TokenizedAddress
	#-- DataMapper
	include DataMapper::Resource
	has n, :address_sets, through: Resource

	property :id, Serial
	property :address, String
	property :number, String
	property :street, String
	property :street_type, String
	property :unit, String
	property :unit_prefix, String
	property :suffix, String
	property :prefix, String
	property :city, String
	property :state, String
	property :postal_code, String
	property :postal_code_ext, String
	#--

	def initialize string, options = {informal: false}
		obj = StreetAddress::US.parse(string, options)
		#TODO catch malformed
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
