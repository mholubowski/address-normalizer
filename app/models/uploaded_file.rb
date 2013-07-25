require 'csv'

class UploadedFile < ActiveRecord::Base
  belongs_to :address_set
  has_one :column_information, dependent: :destroy
  before_create :parse_file

  validate :filename, :with => /.csv/, :message => "File needs to be of .csv format"

  attr_accessor :file

  def column_headers
    # parse self.content -> return [headers]
    CSV.parse(self.content).first
  end

  def row index
    # parse self.content -> return [row]
    CSV.parse(self.content)[index]
  end

  def row_count
    CSV.parse(self.content).count
  end

  private
  def parse_file
    temp = @file.tempfile
    name = @file.original_filename

    self.filename = name
    self.content  = File.read(temp)
  end

end
