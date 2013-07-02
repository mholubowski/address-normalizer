require_relative 'spec_helper'

describe CurrentUser do 

	before :all do

	end

	it "keeps track of set_ids" do
		CurrentUser::set_ids << 43 << 33
		CurrentUser::set_ids.delete 43
		
		CurrentUser::set_ids.should eq([33])
	end

	

end