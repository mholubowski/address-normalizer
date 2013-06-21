# Will serve as a smart collection for TokenizedAddress's
require 'csv'
require_relative '../address_set'

describe AddressSet do

	before :each do
		@set_a = AddressSet.new
		@set_b = AddressSet.new
	end

	it "should accept and appended address with '<<'" do
		@set_a.addresses.should be_empty

		@set_a << 'Test'
		@set_a.addresses.should include('Test')
	end

	it "should merge in another AddressSet" do
		@set_a << 'Example A'
		@set_b << 'Example B'

		@set_a.merge @set_b

		@set_a.addresses.should eq ['Example A', 'Example B']
	end

	it "should find unique occurences of its addresses" do
		@set_a << 'A'
		@set_a << 'A'
		@set_a << 'B'

		@set_a.count_unique_occurences.should eq({'A'=>2, 'B'=>1})
	end

	it "should update unique occurences if an address is added/removed" do
		@set_a << 'A'
		@set_a << 'B'
		@set_a.count_unique_occurences.should eq({'A'=>1, 'B'=>1})

		@set_a << 'A'
		@set_a.count_unique_occurences.should eq({'A'=>2, 'B'=>1})
	end

end