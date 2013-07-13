require 'csv'

class UploadedFile < ActiveRecord::Base
  belongs_to :address_set
  before_create :parse_file

  attr_accessor :file

  def column_headers
    # parse self.content -> return [headers]
    CSV.parse(self.content).first
  end

  def row index
    # parse self.content -> return [row]
    CSV.parse(self.content)[index]
  end

  private
  def parse_file
    temp = @file.tempfile
    name = @file.original_filename

    self.content  = File.read(temp)
    self.filename = name
  end

end
