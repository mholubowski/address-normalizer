require 'street_address'

class AddressTokenizer

	def initialize

	end

	def tokenize(string, options = {informal: true})
		# TODO Catch if Nil (can't parse string)
		obj = StreetAddress::US.parse(string, options)
		return to_hash obj
	end

	def to_hash(obj)
		hash = {}

		hash[:number] 					= obj.number
		hash[:street] 					= obj.street
		hash[:street_type] 			= obj.street_type
		hash[:unit] 						= obj.unit
		hash[:unit_prefix] 			= obj.unit_prefix
		hash[:suffix]					  = obj.suffix
		hash[:prefix] 					= obj.prefix
		hash[:city] 						= obj.city
		hash[:state] 						= obj.state
		hash[:postal_code] 			= obj.postal_code
		hash[:postal_code_ext] 	= obj.postal_code_ext
		hash[:street2]					= obj.street2
		hash[:street_type2] 		= obj.street_type2
		hash[:suffix2]					= obj.suffix2
		hash[:prefix2]					= obj.prefix2
		hash[:prefix2] 					= obj.prefix2
		hash[:state_fips] 			= obj.state_fips
		hash[:state_name] 			= obj.state_name
		hash[:intersection?] 		= obj.intersection?
		hash[:line1] 						= obj.line1

	  return hash
	end

end