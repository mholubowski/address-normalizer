require_relative 'spec_helper'

describe AddressSet do 

	before :each do
		@a = AddressSet.new
		@t1a = TokenizedAddress.create(init_string: '7462 Denrock Ave. Los Angeles')
		@t1b = TokenizedAddress.create(init_string: '7462 Denrock Avenue Los Angeles')
		@t2a = TokenizedAddress.create(init_string: '240 Ofarrel St')
	end

	it "should insert into db" do
		AddressSet.count.should eq(0)
		@a.save
		AddressSet.count.should eq(1)
	end

	it "should respond_to tokenized_addresses" do
		@a.should respond_to(:tokenized_addresses)
	end	

	it "should have many TokenizedAddresses" do
		@a.tokenized_addresses.should_not include @t1a
		@a.tokenized_addresses << @t1a
		@a.tokenized_addresses.should include @t1a
	end

	it "should iterate over TokenizedAddresses with each" do
		@a.tokenized_addresses << @t1a
		@a.each {|addr| addr.should eq(@t1a)}
	end

	it "should properly find unique instances of TokenizedAddress" do
		@a.tokenized_addresses << @t1a
		@a.tokenized_addresses << @t1b
		@a.tokenized_addresses.uniq.should eq([@t1a])
	end

	###------------

	it "should concatenate in another AddressSet" do
		@set_a, @set_b = AddressSet.create, AddressSet.create
		@set_a.tokenized_addresses << @t1a
		@set_b.tokenized_addresses << @t2a

		@set_a.concat @set_b

		@set_a.tokenized_addresses.should eq [@t1a, @t2a]
	end

	it "should find unique occurences of its addresses" do
		@set_a = AddressSet.create
		@set_a.tokenized_addresses.all.destroy

		@set_a.tokenized_addresses << @t1a << @t1b << @t1b << @t2a

		@set_a.count_unique_occurences.should eq({@t1a=>3, @t2a=>1})
	end

	it "should update unique occurences if an address is added/removed" do
		@set_a = AddressSet.create
		@set_a.tokenized_addresses.all.destroy

		@set_a.tokenized_addresses << @t1a << @t1b
		@set_a.count_unique_occurences.should eq({@t1a=>2})

		@set_a.tokenized_addresses << @t1b << @t2a
		@set_a.count_unique_occurences.should eq({@t1a=>3, @t2a=>1})

	end

	it "should return common addresses between two sets with &" do
		@set_a = AddressSet.create
		@set_b = AddressSet.create

		@set_a.tokenized_addresses << @t1a << @t2a
		@set_b.tokenized_addresses << @t1b

		@set_a
		@set_b

		union = @set_a.tokenized_addresses & @set_b.tokenized_addresses
		# binding.pry
		union.should eq([@t1a])
	end

	it "should return common addresses between multiple sets with &..&" do
		@set_a = AddressSet.create
		@set_b = AddressSet.create
		@set_c = AddressSet.create

		@set_a.tokenized_addresses << @t1a
		@set_b.tokenized_addresses << @t1a
		@set_c.tokenized_addresses << @t1b

		(@set_a & @set_b & @set_c).should eq([@t1a])
	end

	after :all do
		AddressSet.all.destroy
		TokenizedAddress.all.destroy
	end

end