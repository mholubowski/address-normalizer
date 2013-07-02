require_relative "spec_helper"
require_relative "../app"

describe AddressNormalizer do

	# before :all do
	# 	@redis = Redis.new
	# end



	it "should connect to Redis" do
		$redis.ping.should eq('PONG')
	end



end