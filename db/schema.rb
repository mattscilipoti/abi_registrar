# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_04_19_040007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lots", force: :cascade do |t|
    t.integer "district"
    t.integer "subdivision"
    t.integer "account_number"
    t.string "lot_number"
    t.integer "section"
    t.decimal "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "property_id"
    t.index ["property_id"], name: "index_lots_on_property_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "street_number"
    t.string "street_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "residencies", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.bigint "resident_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "resident_status"
    t.index ["property_id"], name: "index_residencies_on_property_id"
    t.index ["resident_id"], name: "index_residencies_on_resident_id"
  end

  create_table "residents", force: :cascade do |t|
    t.string "last_name"
    t.text "first_name"
    t.text "email_address"
    t.datetime "verified_at"
    t.boolean "is_minor"
    t.text "age_of_minor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "lots", "properties"
  add_foreign_key "residencies", "properties"
  add_foreign_key "residencies", "residents"
end
