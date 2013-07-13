class TokenizedAddress < ActiveRecord::Base
  belongs_to :address_set

  attr_accessor :init_string
  before_create :use_street_address_gem

  private
  def use_street_address_gem
    obj = StreetAddress::US.parse(@init_string, {informal: true})

    self.address          = obj.to_s

    self.line1           = obj.line1

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
end
