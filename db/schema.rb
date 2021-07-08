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

ActiveRecord::Schema.define(version: 2021_07_07_210549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "encounters", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "encounter_type", limit: 2
    t.index ["encounter_type"], name: "index_encounters_on_encounter_type"
    t.index ["patient_id"], name: "index_encounters_on_patient_id"
    t.index ["provider_id"], name: "index_encounters_on_provider_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "first_name"
    t.integer "sex", limit: 2
    t.date "dob"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "password_digest"
    t.string "last_name"
    t.index ["email"], name: "index_patients_on_email", unique: true
    t.index ["sex"], name: "index_patients_on_sex"
  end

  create_table "providers", force: :cascade do |t|
    t.string "first_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "last_name"
    t.index ["email"], name: "index_providers_on_email", unique: true
  end

  create_table "soaps", force: :cascade do |t|
    t.bigint "encounter_id", null: false
    t.text "chief_complaint"
    t.text "subjective"
    t.text "objective"
    t.text "assessment_and_plan"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["encounter_id"], name: "index_soaps_on_encounter_id"
  end

  add_foreign_key "encounters", "patients"
  add_foreign_key "encounters", "providers"
  add_foreign_key "soaps", "encounters"
end
