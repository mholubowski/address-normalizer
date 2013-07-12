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

ActiveRecord::Schema.define(version: 20130712201928) do

  create_table "address_sets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploaded_files", force: true do |t|
    t.string   "url"
    t.text     "column_headers"
    t.text     "first_row"
    t.text     "second_row"
    t.text     "third_row"
    t.text     "fourth_row"
    t.integer  "address_column_index"
    t.integer  "address_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploaded_files", ["address_set_id"], name: "index_uploaded_files_on_address_set_id"

end
