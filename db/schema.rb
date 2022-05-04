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

ActiveRecord::Schema.define(version: 2022_05_03_145221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string "last_name"
    t.string "other_names"
    t.string "role"
    t.date "employed_from"
    t.date "employed_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "currently_employed"
    t.integer "service_id"
    t.integer "organisation_id"
    t.string "street_address"
    t.string "postal_code"
    t.date "date_of_birth"
    t.boolean "has_dbs_check"
    t.date "dbs_expires_at"
    t.boolean "has_first_aid_training"
    t.date "first_aid_expires_at"
    t.string "qualifications", array: true
    t.boolean "has_food_hygiene"
    t.date "food_hygiene_achieved_on"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
