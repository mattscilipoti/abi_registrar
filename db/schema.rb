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

ActiveRecord::Schema[7.0].define(version: 2022_09_11_225944) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "fuzzystrmatch"
  enable_extension "hstore"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "account_email_auth_keys", force: :cascade do |t|
    t.string   "key",             :null=>false
    t.datetime "deadline",        :null=>false
    t.datetime "email_last_sent", :default=>"CURRENT_TIMESTAMP", :null=>false
  end

  create_table "account_login_change_keys", force: :cascade do |t|
    t.string   "key",      :null=>false
    t.string   "login",    :null=>false
    t.datetime "deadline", :null=>false
  end

  create_table "account_password_reset_keys", force: :cascade do |t|
    t.string   "key",             :null=>false
    t.datetime "deadline",        :null=>false
    t.datetime "email_last_sent", :default=>"CURRENT_TIMESTAMP", :null=>false
  end

  create_table "account_remember_keys", force: :cascade do |t|
    t.string   "key",      :null=>false
    t.datetime "deadline", :null=>false
  end

  create_table "account_verification_keys", force: :cascade do |t|
    t.string   "key",             :null=>false
    t.datetime "requested_at",    :default=>"CURRENT_TIMESTAMP", :null=>false
    t.datetime "email_last_sent", :default=>"CURRENT_TIMESTAMP", :null=>false
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "status",        :default=>1, :null=>false
    t.citext  "email",         :null=>false
    t.string  "password_hash"

    t.index ["email"], :name=>"index_accounts_on_email", :unique=>true, :where=>"(status = ANY (ARRAY[1, 2]))"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "content",          :null=>false
    t.string   "commentable_type", :null=>false
    t.bigint   "commentable_id",   :null=>false
    t.datetime "created_at",       :null=>false
    t.datetime "updated_at",       :null=>false

    t.index ["commentable_type", "commentable_id"], :name=>"index_comments_on_commentable"
  end

  create_table "item_transactions", force: :cascade do |t|
    t.string   "type"
    t.money    "cost_per",          :scale=>2
    t.integer  "quantity",          :default=>0, :null=>false
    t.money    "cost_total",        :scale=>2, :default=>"0.0"
    t.datetime "transacted_at",     :null=>false
    t.datetime "created_at",        :null=>false
    t.datetime "updated_at",        :null=>false
    t.bigint   "residency_id",      :null=>false
    t.string   "activity",          :null=>false
    t.bigint   "from_residency_id"

    t.index ["from_residency_id"], :name=>"index_item_transactions_on_from_residency_id"
    t.index ["residency_id"], :name=>"index_item_transactions_on_residency_id"
  end

  create_table "lots", force: :cascade do |t|
    t.string   "lot_number"
    t.decimal  "size"
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
    t.bigint   "property_id"
    t.date     "paid_on"

    t.index ["lot_number"], :name=>"index_lots_on_lot_number"
    t.index ["paid_on"], :name=>"index_lots_on_paid_on"
    t.index ["property_id"], :name=>"index_lots_on_property_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.bigint   "searchable_id"
    t.datetime "created_at",      :null=>false
    t.datetime "updated_at",      :null=>false

    t.index ["searchable_type", "searchable_id"], :name=>"index_pg_search_documents_on_searchable"
  end

  create_table "properties", force: :cascade do |t|
    t.string   "street_number"
    t.string   "street_name"
    t.datetime "created_at",          :null=>false
    t.datetime "updated_at",          :null=>false
    t.boolean  "membership_eligible"
    t.string   "tax_identifier"
    t.integer  "section"

    t.index ["street_name"], :name=>"index_properties_on_street_name"
    t.index ["street_number"], :name=>"index_properties_on_street_number"
  end

  create_table "residencies", force: :cascade do |t|
    t.bigint   "property_id",       :null=>false
    t.bigint   "resident_id",       :null=>false
    t.datetime "created_at",        :null=>false
    t.datetime "updated_at",        :null=>false
    t.string   "resident_status"
    t.date     "verified_on"
    t.boolean  "primary_residence"

    t.index ["property_id"], :name=>"index_residencies_on_property_id"
    t.index ["resident_id"], :name=>"index_residencies_on_resident_id"
    t.index ["resident_status"], :name=>"index_residencies_on_resident_status"
    t.index ["verified_on"], :name=>"index_residencies_on_verified_on"
  end

  create_table "residents", force: :cascade do |t|
    t.string   "last_name",       :null=>false
    t.text     "first_name"
    t.text     "email_address"
    t.boolean  "is_minor"
    t.datetime "created_at",      :null=>false
    t.datetime "updated_at",      :null=>false
    t.string   "middle_name"
    t.string   "phone"
    t.hstore   "mailing_address"

    t.index ["last_name"], :name=>"index_residents_on_last_name"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string   "tag_number",     :null=>false
    t.integer  "sticker_number", :null=>false
    t.bigint   "resident_id",    :null=>false
    t.datetime "created_at",     :null=>false
    t.datetime "updated_at",     :null=>false
    t.string   "state_code",     :limit=>2

    t.index ["resident_id"], :name=>"index_vehicles_on_resident_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      :null=>false
    t.bigint   "item_id",        :null=>false
    t.string   "event",          :null=>false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"

    t.index ["item_type", "item_id"], :name=>"index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "account_email_auth_keys", "accounts", column: "id"
  add_foreign_key "account_login_change_keys", "accounts", column: "id"
  add_foreign_key "account_password_reset_keys", "accounts", column: "id"
  add_foreign_key "account_remember_keys", "accounts", column: "id"
  add_foreign_key "account_verification_keys", "accounts", column: "id"
  add_foreign_key "item_transactions", "residencies"
  add_foreign_key "item_transactions", "residencies", column: "from_residency_id"
  add_foreign_key "lots", "properties"
  add_foreign_key "residencies", "properties"
  add_foreign_key "residencies", "residents"
  add_foreign_key "vehicles", "residents"
  create_function "pg_search_dmetaphone", "text text", <<-'END_FUNCTION_PG_SEARCH_DMETAPHONE', :force => true
RETURNS text LANGUAGE sql AS $$ SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ') $$
  END_FUNCTION_PG_SEARCH_DMETAPHONE
end
