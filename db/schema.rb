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

ActiveRecord::Schema[7.1].define(version: 2025_09_22_074303) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "medications", force: :cascade do |t|
    t.string "name", null: false
    t.string "dosage", null: false
    t.integer "timing", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.integer "purpose", default: 0, null: false
  end

  create_table "prescription_items", force: :cascade do |t|
    t.bigint "prescription_id", null: false
    t.bigint "medication_id", null: false
    t.integer "days", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_id"], name: "index_prescription_items_on_medication_id"
    t.index ["prescription_id"], name: "index_prescription_items_on_prescription_id"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "doctor_id", null: false
    t.datetime "issued_at", null: false
    t.datetime "expires_at", null: false
    t.string "qr_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hospital_name"
    t.string "patient_name"
    t.string "patient_code"
    t.string "patient_number"
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
    t.integer "role", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hospital_name"
    t.string "patient_code"
    t.integer "patient_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["patient_code"], name: "index_users_on_patient_code", unique: true
    t.index ["patient_number"], name: "index_users_on_patient_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "prescription_items", "medications"
  add_foreign_key "prescription_items", "prescriptions"
  add_foreign_key "prescriptions", "users", column: "doctor_id"
  add_foreign_key "prescriptions", "users", column: "patient_id"
  add_foreign_key "status_updates", "prescriptions"
  add_foreign_key "status_updates", "users", column: "pharmacy_id"
end
