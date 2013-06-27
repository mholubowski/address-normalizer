require_relative 'spec_helper'

describe TokenizedAddress do 

	before :all do
		@t = TokenizedAddress.new(init_string: '7462 Denrock Ave. Los Angeles')
		@a = AddressSet.create
	end

	it "should insert into db" do
		TokenizedAddress.count.should eq(0)
		@t.save
		TokenizedAddress.count.should eq(1)
	end

	it "should respond_to address_sets" do
		@t.should respond_to(:address_sets)
	end	

	it "should belong to an AddressSet" do
		@a.tokenized_addresses.should_not include @t
		@a.tokenized_addresses << @t
		@a.tokenized_addresses.should include @t
	end

end