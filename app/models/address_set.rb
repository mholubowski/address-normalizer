class AddressSet < ActiveRecord::Base
  has_one :uploaded_file
  has_many :tokenized_addresses

  def error_count
    self.tokenized_addresses.where(address: 'ERROR').count
  end

  def uniq_addresses
    self.tokenized_addresses.to_a.uniq
  end

end
