require_relative 'spec_helper'

describe TokenizedAddress do 

	before :all do
		@t1a = TokenizedAddress.new('7462 Denrock Ave. Los Angeles')
		@t1b = TokenizedAddress.new('7462 Denrock Avenue Los Angeles')
		
		@t2a = TokenizedAddress.new('240 Ofarrel St')

		@a = AddressSet.new

		# @redis = Redis.new
	end

	# it "should insert into db" do
	# 	TokenizedAddress.count.should eq(0)
	# 	@t1a.save; @t1b.save; @t2a.save
	# 	TokenizedAddress.count.should eq(3)
	# end

	# it "should respond_to address_sets" do
	# 	@t1a.should respond_to(:address_sets)
	# end	

	it "should belong to an AddressSet" do
		@a.tokenized_addresses.should_not include @t1a
		@a.tokenized_addresses << @t1a
		@a.tokenized_addresses.should include @t1a
	end

	it "should be equal (==) to another TokenizedAddress" do
		(@t1a == @t1b).should eq(true)

		(@t1a == @t2a).should_not eq(true)		
	end

	it "should return its address_id when .to_redis is called" do
		@t1a.to_redis.should eq(1)
		@t1b.to_redis.should eq(2)
	end

	it "should insert itself into redis hash on .to_redis" do
		pending
	end


	# after :all do
	# 	AddressSet.all.destroy
	# 	TokenizedAddress.all.destroy
	# end

	after :all do
		$redis.flushdb
	end

end