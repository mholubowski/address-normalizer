require_relative 'spec_helper'

describe CurrentUser do 

	before :all do 
	end

	it "CurrentUser::set_ids keeps track of set_ids" do
		CurrentUser::set_ids.clear
		CurrentUser::set_ids << 43 << 33 << 33
		CurrentUser::set_ids.delete 43
		
		CurrentUser::set_ids.to_a.should eq([33])
	end



end