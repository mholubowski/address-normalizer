class CreateAddressSets < ActiveRecord::Migration
  def up
  	create_table :address_sets do |t|

  	end
  end

  def down
  	drop_table :address_sets
  end
end
