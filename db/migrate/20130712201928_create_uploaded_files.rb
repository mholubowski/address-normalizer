class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.string :url
      t.text :column_headers
      t.text :first_row
      t.text :second_row
      t.text :third_row
      t.text :fourth_row
      t.integer :address_column_index
      t.references :address_set, index: true

      t.timestamps
    end
  end
end
