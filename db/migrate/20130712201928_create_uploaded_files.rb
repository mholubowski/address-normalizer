class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.string :filename
      t.text :content
      t.integer :address_column_index
      t.references :address_set, index: true

      t.timestamps
    end
  end
end
