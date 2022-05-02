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

ActiveRecord::Schema[7.0].define(version: 2022_05_01_220254) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "item_transactions", force: :cascade do |t|
    t.string "type"
    t.money "cost_per", scale: 2
    t.integer "quantity", default: 0
    t.money "cost_total", scale: 2, default: "0.0"
    t.datetime "transacted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "residency_id"
    t.integer "activity"
    t.bigint "from_residency_id"
    t.index ["from_residency_id"], name: "index_item_transactions_on_from_residency_id"
    t.index ["residency_id"], name: "index_item_transactions_on_residency_id"
  end

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
    t.date "paid_on"
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
    t.date "verified_on"
    t.index ["property_id"], name: "index_residencies_on_property_id"
    t.index ["resident_id"], name: "index_residencies_on_resident_id"
  end

  create_table "residents", force: :cascade do |t|
    t.string "last_name"
    t.text "first_name"
    t.text "email_address"
    t.boolean "is_minor"
    t.text "age_of_minor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "item_transactions", "residencies"
  add_foreign_key "item_transactions", "residencies", column: "from_residency_id"
  add_foreign_key "lots", "properties"
  add_foreign_key "residencies", "properties"
  add_foreign_key "residencies", "residents"
end
