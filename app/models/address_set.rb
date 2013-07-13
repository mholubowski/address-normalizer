class AddressSet < ActiveRecord::Base
  has_one :uploaded_file
  has_many :tokenized_addresses

end
