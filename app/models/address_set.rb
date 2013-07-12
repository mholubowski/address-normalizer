class AddressSet < ActiveRecord::Base
  has_one :uploaded_file
  validates :file_location, presence: true
  validates :file_name, presence: true


end
