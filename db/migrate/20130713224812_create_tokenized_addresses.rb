class CreateTokenizedAddresses < ActiveRecord::Migration
  def change
    create_table :tokenized_addresses do |t|
      t.string :address
      t.string :line1
      t.string :number
      t.string :street
      t.string :street_type
      t.string :unit
      t.string :unit_prefix
      t.string :suffix
      t.string :prefix
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :postal_code_ext
      t.references :address_set, index: true

      t.timestamps
    end
  end
end
