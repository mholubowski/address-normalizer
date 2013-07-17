class CreateColumnInformations < ActiveRecord::Migration
  def change
    create_table :column_informations do |t|
      t.boolean :single_column_address
      t.integer :single_column_index
      t.integer :number_index
      t.integer :street_index
      t.integer :street_type_index
      t.integer :unit_index
      t.integer :unit_prefix_index
      t.integer :suffix_index
      t.integer :prefix_index
      t.integer :city_index
      t.integer :state_index
      t.integer :postal_code_index
      t.integer :postal_code_ext_index
      t.references :uploaded_file, index: true

      t.timestamps
    end
  end
end
