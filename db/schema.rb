# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130717220114) do

  create_table "address_sets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "column_informations", force: true do |t|
    t.boolean  "single_column_address"
    t.integer  "single_column_index"
    t.integer  "number_index"
    t.integer  "street_index"
    t.integer  "street_type_index"
    t.integer  "unit_index"
    t.integer  "unit_prefix_index"
    t.integer  "suffix_index"
    t.integer  "prefix_index"
    t.integer  "city_index"
    t.integer  "state_index"
    t.integer  "postal_code_index"
    t.integer  "postal_code_ext_index"
    t.integer  "uploaded_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "column_informations", ["uploaded_file_id"], name: "index_column_informations_on_uploaded_file_id"

  create_table "tokenized_addresses", force: true do |t|
    t.string   "address"
    t.string   "line1"
    t.string   "number"
    t.string   "street"
    t.string   "street_type"
    t.string   "unit"
    t.string   "unit_prefix"
    t.string   "suffix"
    t.string   "prefix"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "postal_code_ext"
    t.integer  "address_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tokenized_addresses", ["address_set_id"], name: "index_tokenized_addresses_on_address_set_id"

  create_table "uploaded_files", force: true do |t|
    t.string   "filename"
    t.text     "content"
    t.integer  "address_column_index"
    t.integer  "address_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploaded_files", ["address_set_id"], name: "index_uploaded_files_on_address_set_id"

end
