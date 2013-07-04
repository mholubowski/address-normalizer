require_relative 'spec_helper'

describe AddressSet do

	before :each do
		$redis.flushall
	end

	before :each do
		@a = AddressSet.new
		@t1a = TokenizedAddress.new('7462 Denrock Ave. Los Angeles')
		@t1b = TokenizedAddress.new('7462 Denrock Avenue Los Angeles')
		@t2a = TokenizedAddress.new('240 Ofarrel St')
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
		filename = './spec/example_data/test1.csv'
		@set = FileParser.instance.create_address_set({filename: filename})
		@set.stats[:filename].should eq('test1.csv')
	end

	#---------- Redis

	it ".save should store it in redis" do
		counter = $redis.get('global:set_id')

		set_a = AddressSet.new
		set_a.tokenized_addresses << @t1a << @t1b
		set_a.save

		$redis.get('global:set_id').should eq('1')

		$redis.lrange('set_id:1:address_ids', 0, -1).should eq(['1','2'])
	end

	it ".save should also store addresses" do
		counter = $redis.get('global:address_id').to_i

		set_a = AddressSet.new
		set_a.tokenized_addresses << @t1a << @t1b

		set_a.save

		$redis.get('global:address_id').to_i.should eq(counter + 2)
	end

	it ".save should store stats hash" do
		set_a = AddressSet.new
		set_a.stats = {'user'=> 'Mike', "num_addresses"=> "1232"}
		set_a.stats_save

		$redis.hgetall("set_id:#{set_a.redis_id}:stats").should eq(set_a.stats)
	end

	it "AddressSet.find_addresses(id) and pulls from redis" do
		set_a = AddressSet.new
		set_a.tokenized_addresses << @t1a << @t1b
		set_a.save

		response = AddressSet.find_addresses(1)
		response[0]['street'].should eq('Denrock')
	end

	it "redis_id should work" do
		set_a = AddressSet.new
		set_a.redis_id.should eq(1)
		set_a.redis_id.should eq(1)
	end

	it "should have option to set default id" do
		set_a =AddressSet.new({id:1000})
		set_a.redis_id.should equal(1000)
	end

	it "AddressSet.find(id) should reconstruct an AddressSet" do
		set_a = AddressSet.new({filename: 'data.csv'})
		set_a.tokenized_addresses << @t1a << @t1a<< @t2a
		set_a.save

		temp = AddressSet.find(set_a.redis_id)

		temp.class.should eq(AddressSet)
		temp.stats['filename'].should eq('data.csv')
		temp.count.should eq(3)
		temp.count_unique_occurences.count.should eq(2)
	end

	it ".to_csv should export csv" do
		set_a = AddressSet.new({filename: 'test1.csv'})
		set_a.addon_export
		pending
	end

	after :each do
		$redis.flushdb
	end

end
