class CreateAddressSets < ActiveRecord::Migration
  def change
    create_table :address_sets do |t|

      t.timestamps
    end
  end
end
