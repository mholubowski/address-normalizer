require_relative '../api_address_verifier'

describe ApiAddressVerifier do 

	before :all do
		@AV = ApiAddressVerifier.new
		@address = {number: "6587", street: "Del Playa", street_type: "Dr", unit: nil, unit_prefix: nil, suffix: nil, prefix: nil, city: "Isla Vista", state: "CA", postal_code: "93117", postal_code_ext: nil, street2: nil, street_type2: nil, suffix2: nil, prefix2: nil, state_fips: "06", state_name: "California", intersection?: false, line1: "6587 Del Playa Dr"}
	end

  it "should remove all nil elements from address_hash" do
  	@AV.create_easypost_call(@address)

  	@address.any? {|key,value| value.nil?}.should eq(false)
  end

  it "should convert has to EasyPost form" do 
		@AV.create_easypost_call(@address)

		@address[:street1].should eq("6587 Del Playa Dr")  	
		@address[:zip].should eq("93117")
  end

	it "should accept a hash and create a lambda Easypost call" do
    ep_call = @AV.create_easypost_call(@address)

    ep_call.class.should eq(Proc)
  end

end