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

ActiveRecord::Schema[7.2].define(version: 2024_08_21_052329) do
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

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "contacts"
    t.text "address"
    t.string "partner"
    t.bigint "tin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.string "unit"
    t.decimal "price"
    t.string "brand"
    t.text "description"
    t.text "specs"
    t.text "terms"
    t.text "remarks"
    t.string "image"
    t.bigint "quotation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quotation_id"], name: "index_products_on_quotation_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "uid"
    t.bigint "client_id", null: false
    t.integer "status"
    t.decimal "amount"
    t.integer "payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company"
    t.index ["client_id"], name: "index_projects_on_client_id"
  end

  create_table "quotations", force: :cascade do |t|
    t.string "uid"
    t.bigint "client_id", null: false
    t.string "attention"
    t.string "vessel"
    t.string "subject"
    t.text "remarks"
    t.string "payment"
    t.text "lead_time"
    t.text "warranty"
    t.decimal "sub_total"
    t.decimal "total"
    t.decimal "vat"
    t.text "additional_conditions"
    t.string "preparer"
    t.string "approver"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company"
    t.index ["client_id"], name: "index_quotations_on_client_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "products", "quotations"
  add_foreign_key "projects", "clients"
  add_foreign_key "quotations", "clients"
end
