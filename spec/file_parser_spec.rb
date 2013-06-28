# Will process CSV to combine Columns into single 
# address string
require_relative 'spec_helper'

describe FileParser do 

	before :all do
		@filename = './spec/example_data/test.csv'
		@parser = FileParser.new
	end

	it "should return a AddressSet" do
		@set = @parser.create_address_set(@filename)
		@set.class.should eq(AddressSet)
	end

end