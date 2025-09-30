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

ActiveRecord::Schema[7.1].define(version: 2025_10_01_000000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "medication_intakes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "prescription_item_id", null: false
    t.datetime "taken_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prescription_item_id"], name: "index_medication_intakes_on_prescription_item_id"
    t.index ["user_id"], name: "index_medication_intakes_on_user_id"
  end

  create_table "medications", force: :cascade do |t|
    t.string "name", null: false
    t.string "dosage", null: false
    t.integer "timing", null: false
    t.integer "purpose", default: 0
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prescription_items", force: :cascade do |t|
    t.bigint "prescription_id", null: false
    t.bigint "medication_id", null: false
    t.string "dosage", null: false
    t.string "timing", null: false
    t.integer "days", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_id"], name: "index_prescription_items_on_medication_id"
    t.index ["prescription_id"], name: "index_prescription_items_on_prescription_id"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.bigint "patient_id"
    t.string "patient_name", limit: 50, null: false
    t.string "hospital_name"
    t.string "patient_code"
    t.string "patient_number"
    t.date "issued_at", null: false
    t.date "expires_at", null: false
    t.string "qr_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_prescriptions_on_doctor_id"
    t.index ["patient_id"], name: "index_prescriptions_on_patient_id"
    t.index ["qr_token"], name: "index_prescriptions_on_qr_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.integer "role", default: 2, null: false
    t.string "hospital_name"
    t.string "patient_code"
    t.integer "patient_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["patient_number"], name: "index_users_on_patient_number", unique: true
  end

  add_foreign_key "medication_intakes", "prescription_items"
  add_foreign_key "medication_intakes", "users"
  add_foreign_key "prescription_items", "medications"
  add_foreign_key "prescription_items", "prescriptions"
  add_foreign_key "prescriptions", "users", column: "doctor_id"
  add_foreign_key "prescriptions", "users", column: "patient_id"
end
