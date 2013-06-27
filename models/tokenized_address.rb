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
	property :init_string, String
	#--

	before :save, :create_using_street_address_gem

	def create_using_street_address_gem 
		options = {informal: true}
		string  = @init_string

		obj = StreetAddress::US.parse(string, options)
		#TODO catch malformed
		return if obj.nil?

		self.address 					= obj.to_s
		self.number  					= obj.number 
		self.street  					= obj.street
		self.street_type 			= obj.street_type
		self.unit 			 			= obj.unit
		self.unit_prefix 			= obj.unit_prefix
		self.suffix 					= obj.suffix
		self.prefix 					= obj.prefix
		self.city   					= obj.city
		self.state  					= obj.state
		self.postal_code 			= obj.postal_code
		self.postal_code_ext  = obj.postal_code_ext
	end

end
