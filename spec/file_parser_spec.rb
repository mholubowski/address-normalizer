# Will process CSV to combine Columns into single 
# address string
require_relative 'spec_helper'

describe FileParser do 

	before :all do
		@filename = './spec/example_data/test.csv'
		@parser = FileParser.new
		@set = @parser.create_address_set(@filename)
	end

	it "should return a AddressSet" do
		@set.class.should eq(AddressSet)
	end

	it "should create an AddressSet with TokenizedAddresses" do
		@set.tokenized_addresses[0].class.should eq(TokenizedAddress)
	end

	it "should properly create TokenizedAddresses" do
		@t = @set.tokenized_addresses[0]
		@t.should respond_to(:street)
		@t.street.should eq('Denrock')
	end

end