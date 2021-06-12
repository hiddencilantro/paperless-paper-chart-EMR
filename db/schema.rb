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

ActiveRecord::Schema.define(version: 2021_06_11_205503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "encounters", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.bigint "patient_id", null: false
    t.text "chief_complaint"
    t.text "subjective"
    t.text "objective"
    t.text "assessment_and_plan"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["patient_id"], name: "index_encounters_on_patient_id"
    t.index ["provider_id"], name: "index_encounters_on_provider_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "name"
    t.integer "sex", limit: 2, default: 0
    t.date "dob"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sex"], name: "index_patients_on_sex"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_providers_on_username", unique: true
  end

  add_foreign_key "encounters", "patients"
  add_foreign_key "encounters", "providers"
end