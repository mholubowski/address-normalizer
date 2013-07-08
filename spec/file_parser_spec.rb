# Will process CSV to combine Columns into single
# address string
require_relative 'spec_helper'

describe FileParser do

	before :all do
		filename = Dir.pwd + "/spec/example_data/test1.csv"
		@set = FileParser.instance.create_address_set({filename: filename})
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

	it ".find_index_with_regex should work" do
		r = /postal|zip/
		array = ['street', 'zip', 'state']
		FileParser.instance.find_index_with_regex(array, r).should eq(1)
	end

end
