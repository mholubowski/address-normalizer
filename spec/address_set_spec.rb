# Will serve as a smart collection for TokenizedAddress's
require 'csv'
require_relative '../address_set'

describe AddressSet do

	before :each do
		@set_a = AddressSet.new
		@set_b = AddressSet.new
		@set_c = AddressSet.new
	end

	it "should accept and appended address with '<<'" do
		@set_a.addresses.should be_empty

		@set_a << 'Test'
		@set_a.addresses.should include('Test')
	end

	it "should concatenate in another AddressSet" do
		@set_a << 'Example A'
		@set_b << 'Example B'

		@set_a.concat @set_b

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

	it "should return common addresses between two sets with &" do
		@set_a << 'A'
		@set_a << 'B'

		@set_b << 'B'
		@set_b << 'C'

		(@set_a & @set_b).should eq(['B'])
	end

	it "should return common addresses between multiple sets with &..&" do
		@set_a << 'A'
		@set_a << 'B'

		@set_b << 'B'
		@set_b << 'C'

		@set_c << 'B'

		(@set_a & @set_b & @set_c).should eq(['B'])
	end

end