require 'bundler'
Bundler.require :default, :test
require_relative '../app'
require 'benchmark'
# require 'normalic'

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
		temp.save
	end

	bm.report("Set from Redis") do
		set = AddressSet.find(temp.redis_id)
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
		temp.save
	end

	bm.report("Set from Redis") do
		set = AddressSet.find(temp.redis_id)
	end
end

Benchmark.bm do |bm|
	bm.report('street address') do
		100.times do
			StreetAddress::US.parse('7462 Denrock Ave Los Angeles, CA, 90045')
		end
	end
	bm.report('street address') do
		100.times do
			Normalic::Address.parse('7462 Denrock Ave Los Angeles, CA, 90045')
		end
	end
end


