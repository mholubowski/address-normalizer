require_relative '../api_address_verifier'

describe ApiAddressVerifier do

  before :all do
    @AV = ApiAddressVerifier.new
    @address = {
      :number=>"6587", 					:street=>"Del Playa",
      :street_type=>"Dr",  			:unit=>nil,
      :unit_prefix=>nil,   			:suffix=>nil,
      :prefix=>nil, 			  			:city=>"Isla Vista",
      :state=>"CA", 							:postal_code=>"93117",
      :postal_code_ext=>nil, 		:street2=>nil,
      :street_type2=>nil, 				:suffix2=>nil,
      :prefix2=>nil, 						:state_fips=>"06",
      :state_name=>"California", :intersection?=>false,
      :line1=>"6587 Del Playa Dr"
    }
  end

  it "should accept a hash and create a lambda Easypost call" do
    call = @AV.create_easy_post_call(@address)

    call.class.should eq(Proc)
  end

end
