require_relative 'spec_helper'

describe AddressSet do

	before :each do
		@a = AddressSet.new
		@t1a = TokenizedAddress.new('7462 Denrock Ave. Los Angeles')
		@t1b = TokenizedAddress.new('7462 Denrock Avenue Los Angeles')
		@t2a = TokenizedAddress.new('240 Ofarrel St')
	end

	# it "should insert into db" do
	# 	AddressSet.count.should eq(0)
	# 	@a.save
	# 	AddressSet.count.should eq(1)
	# end

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
		@set_a, @set_b = AddressSet.new, AddressSet.new
		@set_a.tokenized_addresses << @t1a
		@set_b.tokenized_addresses << @t2a

		@set_a.concat @set_b

		@set_a.tokenized_addresses.should eq [@t1a, @t2a]
	end

	it "should find unique occurences of its addresses" do
		@set_a = AddressSet.new

		@set_a.tokenized_addresses << @t1a << @t1b << @t1b << @t2a

		@set_a.count_unique_occurences.should eq({@t1a=>3, @t2a=>1})
	end

	it "should update unique occurences if an address is added/removed" do
		@set_a = AddressSet.new

		@set_a.tokenized_addresses << @t1a << @t1b
		@set_a.count_unique_occurences.should eq({@t1a=>2})

		@set_a.tokenized_addresses << @t1b << @t2a
		@set_a.count_unique_occurences.should eq({@t1a=>3, @t2a=>1})

	end

	it "should return common addresses between two sets with &" do
		@set_a = AddressSet.new
		@set_b = AddressSet.new

		@set_a.tokenized_addresses << @t1a << @t2a
		@set_b.tokenized_addresses << @t1b

		@set_a
		@set_b

		union = @set_a.tokenized_addresses & @set_b.tokenized_addresses
		# binding.pry
		union.should eq([@t1a])
	end

	it "should return common addresses between multiple sets with &..&" do
		@set_a = AddressSet.new
		@set_b = AddressSet.new
		@set_c = AddressSet.new

		@set_a.tokenized_addresses << @t1a
		@set_b.tokenized_addresses << @t1a
		@set_c.tokenized_addresses << @t1b

		(@set_a.tokenized_addresses & @set_b.tokenized_addresses & @set_c.tokenized_addresses).should eq([@t1a])
	end

	it "should store its filename in stats" do 
		@filename = './spec/example_data/test1.csv'
		@set = FileParser.new.create_address_set(@filename)
		@set.stats[:filename].should eq('test1.csv')
	end

	after :all do

	end

end