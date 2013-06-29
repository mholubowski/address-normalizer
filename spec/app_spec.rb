require_relative "spec_helper"

describe AddressNormalizer do

	it "should find AddressSets by random_hash" do
		sets = []
		a1, a2 = AddressSet.new, AddressSet.new
		id1, id2 = a1.random_hash, a2.random_hash

		sets << a1 << a2
		
		sets.find_set_by_hash(id1).should eq(a1)
		sets.find_set_by_hash(id2).should eq(a2)
	end

	it "should destroy AddressSets by random_hash" do
		sets = []
		a1, a2 = AddressSet.new, AddressSet.new
		id1, id2 = a1.random_hash, a2.random_hash

		sets << a1 << a2
		
		sets.destroy_set_by_hash(id1)
		sets.should_not include(a1)
		sets.should include(a2)

		sets.destroy_set_by_hash(id2)
		sets.should_not include(a2)
	end



end