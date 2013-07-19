class TokenizedAddress < ActiveRecord::Base
  belongs_to :address_set

  attr_accessor :init_string
  before_create :use_street_address_gem

  # private
  def use_street_address_gem
    obj = StreetAddress::US.parse(@init_string, {informal: true}) 
    #TODO handle errors better
    return self.address = 'ERROR' if obj.nil?

    self.address          = obj.to_s

    self.line1            = obj.line1

    self.number           = obj.number
    self.street           = obj.street
    self.street_type      = obj.street_type
    self.unit             = obj.unit
    self.unit_prefix      = obj.unit_prefix
    self.suffix           = obj.suffix
    self.prefix           = obj.prefix
    self.city             = obj.city
    self.state            = obj.state
    self.postal_code      = obj.postal_code
    self.postal_code_ext  = obj.postal_code_ext
  end

  def == (other_object)
    self.to_hash == other_object.to_hash
  end

  def to_hash
    obj = {}

    obj[:address]         = self.address
    obj[:line1]           = self.line1
    obj[:number]          = self.number
    obj[:street]          = self.street
    obj[:street_type]     = self.street_type
    obj[:unit]            = self.unit
    obj[:unit_prefix]     = self.unit_prefix
    obj[:suffix]          = self.suffix
    obj[:prefix]          = self.prefix
    obj[:city]            = self.city
    obj[:state]           = self.state
    obj[:postal_code]     = self.postal_code
    obj[:postal_code_ext] = self.postal_code_ext

    return obj
  end

  def hash
    self.to_hash.hash
  end

  def eql? (other_object)
    self == other_object
  end
end
