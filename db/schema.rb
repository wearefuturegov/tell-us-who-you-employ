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

ActiveRecord::Schema.define(version: 2024_02_28_104107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string "surname"
    t.string "forenames"
    t.string "job_title"
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
    t.date "dbs_achieved_on"
    t.boolean "has_first_aid_training"
    t.date "first_aid_achieved_on"
    t.string "qualifications", array: true
    t.boolean "has_food_hygiene"
    t.date "food_hygiene_achieved_on"
    t.string "roles", array: true
    t.boolean "has_senco_training"
    t.date "senco_achieved_on"
    t.boolean "has_senco_early_years"
    t.date "senco_early_years_achieved_on"
    t.boolean "has_safeguarding"
    t.date "safeguarding_achieved_on"
    t.datetime "marked_for_deletion"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
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
