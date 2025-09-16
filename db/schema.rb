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

ActiveRecord::Schema[7.1].define(version: 2025_09_16_073710) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "medications", force: :cascade do |t|
    t.bigint "prescription_id", null: false
    t.string "name", null: false
    t.string "dosage", null: false
    t.integer "timing", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prescription_id"], name: "index_medications_on_prescription_id"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "doctor_id", null: false
    t.datetime "issued_at", null: false
    t.datetime "expires_at", null: false
    t.string "qr_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_prescriptions_on_doctor_id"
    t.index ["patient_id"], name: "index_prescriptions_on_patient_id"
    t.index ["qr_token"], name: "index_prescriptions_on_qr_token", unique: true
  end

  create_table "status_updates", force: :cascade do |t|
    t.bigint "prescription_id", null: false
    t.bigint "pharmacy_id", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pharmacy_id"], name: "index_status_updates_on_pharmacy_id"
    t.index ["prescription_id"], name: "index_status_updates_on_prescription_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "medications", "prescriptions"
  add_foreign_key "prescriptions", "users", column: "doctor_id"
  add_foreign_key "prescriptions", "users", column: "patient_id"
  add_foreign_key "status_updates", "prescriptions"
  add_foreign_key "status_updates", "users", column: "pharmacy_id"
end
