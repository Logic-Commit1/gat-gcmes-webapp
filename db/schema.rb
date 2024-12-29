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

ActiveRecord::Schema[7.2].define(version: 2024_12_29_050318) do
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

  create_table "canvasses", force: :cascade do |t|
    t.string "uid"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "suppliers", default: []
    t.string "description"
    t.integer "quantity", default: 0
    t.string "unit"
    t.datetime "deleted_at"
    t.integer "status", default: 0
    t.bigint "project_id", null: false
    t.index ["company_id"], name: "index_canvasses_on_company_id"
    t.index ["deleted_at"], name: "index_canvasses_on_deleted_at"
    t.index ["project_id"], name: "index_canvasses_on_project_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.text "address"
    t.string "partner"
    t.bigint "tin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_clients_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.text "address"
    t.bigint "tin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "contact_numbers", default: []
    t.jsonb "emails", default: []
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.jsonb "emails", default: []
    t.jsonb "contact_numbers", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contactable_type", null: false
    t.bigint "contactable_id", null: false
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "contact_number"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "particulars", force: :cascade do |t|
    t.string "name"
    t.decimal "allowance"
    t.bigint "request_form_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "remarks"
    t.index ["request_form_id"], name: "index_particulars_on_request_form_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.string "unit"
    t.decimal "price", default: "0.0"
    t.string "brand"
    t.text "description"
    t.jsonb "specs", default: []
    t.text "terms"
    t.text "remarks"
    t.string "image"
    t.bigint "quotation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "discount", default: "0.0"
    t.decimal "total", default: "0.0"
    t.bigint "canvass_id"
    t.bigint "supplier_id"
    t.bigint "request_form_id"
    t.bigint "purchase_order_id"
    t.index ["canvass_id"], name: "index_products_on_canvass_id"
    t.index ["purchase_order_id"], name: "index_products_on_purchase_order_id"
    t.index ["quotation_id"], name: "index_products_on_quotation_id"
    t.index ["request_form_id"], name: "index_products_on_request_form_id"
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "uid"
    t.bigint "client_id", null: false
    t.integer "status", default: 0
    t.decimal "amount", default: "0.0"
    t.integer "payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.string "po_number"
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["company_id"], name: "index_projects_on_company_id"
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string "uid"
    t.string "preparer"
    t.integer "terms"
    t.decimal "total"
    t.decimal "discount"
    t.string "requester"
    t.string "checker"
    t.string "pre_approver"
    t.string "approver"
    t.bigint "company_id", null: false
    t.bigint "supplier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id"
    t.bigint "request_form_id"
    t.datetime "deleted_at"
    t.bigint "project_id", null: false
    t.integer "status", default: 0
    t.index ["company_id"], name: "index_purchase_orders_on_company_id"
    t.index ["deleted_at"], name: "index_purchase_orders_on_deleted_at"
    t.index ["employee_id"], name: "index_purchase_orders_on_employee_id"
    t.index ["project_id"], name: "index_purchase_orders_on_project_id"
    t.index ["request_form_id"], name: "index_purchase_orders_on_request_form_id"
    t.index ["supplier_id"], name: "index_purchase_orders_on_supplier_id"
  end

  create_table "quotations", force: :cascade do |t|
    t.string "uid"
    t.bigint "client_id", null: false
    t.string "attention"
    t.string "vessel"
    t.string "subject"
    t.text "remarks"
    t.integer "payment"
    t.text "lead_time"
    t.text "warranty"
    t.decimal "sub_total", default: "0.0"
    t.decimal "total", default: "0.0"
    t.decimal "vat", default: "0.0"
    t.text "additional_conditions"
    t.string "preparer"
    t.string "approver"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.bigint "project_id"
    t.integer "status", default: 0
    t.datetime "deleted_at"
    t.decimal "discount", default: "0.0"
    t.decimal "discount_rate", default: "0.0"
    t.index ["client_id"], name: "index_quotations_on_client_id"
    t.index ["company_id"], name: "index_quotations_on_company_id"
    t.index ["deleted_at"], name: "index_quotations_on_deleted_at"
    t.index ["project_id"], name: "index_quotations_on_project_id"
  end

  create_table "request_form_sequences", force: :cascade do |t|
    t.string "request_type"
    t.integer "last_sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "request_forms", force: :cascade do |t|
    t.string "uid"
    t.integer "request_type"
    t.string "vehicle"
    t.string "destination"
    t.decimal "total"
    t.text "remarks"
    t.string "fuel_gauge"
    t.decimal "easy_trip_balance"
    t.decimal "sweep_balance"
    t.string "requester"
    t.string "checker"
    t.string "procurer"
    t.string "pre_approver"
    t.string "approver"
    t.bigint "canvass_id"
    t.bigint "quotation_id"
    t.bigint "company_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_travel_date"
    t.datetime "end_travel_date"
    t.integer "sequence_id"
    t.datetime "deleted_at"
    t.integer "status", default: 0
    t.index ["canvass_id"], name: "index_request_forms_on_canvass_id"
    t.index ["company_id"], name: "index_request_forms_on_company_id"
    t.index ["deleted_at"], name: "index_request_forms_on_deleted_at"
    t.index ["project_id"], name: "index_request_forms_on_project_id"
    t.index ["quotation_id"], name: "index_request_forms_on_quotation_id"
  end

  create_table "specs", force: :cascade do |t|
    t.string "name", null: false
    t.string "value", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_specs_on_product_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.text "address"
    t.string "tin"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_suppliers_on_company_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "canvasses", "companies"
  add_foreign_key "canvasses", "projects"
  add_foreign_key "clients", "companies"
  add_foreign_key "particulars", "request_forms"
  add_foreign_key "products", "canvasses"
  add_foreign_key "products", "purchase_orders"
  add_foreign_key "products", "quotations"
  add_foreign_key "products", "request_forms"
  add_foreign_key "products", "suppliers"
  add_foreign_key "projects", "clients"
  add_foreign_key "projects", "companies"
  add_foreign_key "purchase_orders", "companies"
  add_foreign_key "purchase_orders", "employees"
  add_foreign_key "purchase_orders", "projects"
  add_foreign_key "purchase_orders", "request_forms"
  add_foreign_key "purchase_orders", "suppliers"
  add_foreign_key "quotations", "clients"
  add_foreign_key "quotations", "companies"
  add_foreign_key "quotations", "projects"
  add_foreign_key "request_forms", "canvasses"
  add_foreign_key "request_forms", "companies"
  add_foreign_key "request_forms", "projects"
  add_foreign_key "request_forms", "quotations"
  add_foreign_key "specs", "products"
  add_foreign_key "suppliers", "companies"
end
