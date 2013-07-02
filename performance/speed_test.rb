require 'bundler'
Bundler.require :default, :test
require_relative '../app'
require 'benchmark'

puts ""
puts "             *************** Speed Test *************** "
puts ""



temp = AddressSet.new 
temp.stats = {'filename' => 'data.csv'} 
Benchmark.bm(20) do |bm|	
	bm.report("1 TokenizedAddress") do
		1.times do 
				temp.tokenized_addresses << TokenizedAddress.new('7462 Denrock Ave. Los Angeles, CA 90045') 
		end 
	end

	bm.report("Set to Redis") do
		temp.to_redis 
	end

	bm.report("Set from Redis") do
		set = AddressSet.from_redis(temp.redis_id) 
	end
end

temp = AddressSet.new 
temp.stats = {'filename' => 'data.csv'} 
Benchmark.bm(20) do |bm|	
	bm.report("10 TokenizedAddresses") do
		10.times do 
				temp.tokenized_addresses << TokenizedAddress.new('7462 Denrock Ave. Los Angeles, CA 90045') 
		end 
	end

	bm.report("Set to Redis") do
		temp.to_redis 
	end

	bm.report("Set from Redis") do
		set = AddressSet.from_redis(temp.redis_id) 
	end
	
end
