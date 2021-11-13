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

ActiveRecord::Schema.define(version: 2019_06_03_214304) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "body_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.datetime "deleted_at"
    t.integer "vehicle_type_id"
  end

  create_table "colors", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "conditions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "damages", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "disclosures", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "body"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drivables", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "body"
    t.datetime "deleted_at"
  end

  create_table "engines", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "features", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "order"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inquiries", id: :serial, force: :cascade do |t|
    t.integer "subscriber_id"
    t.integer "vehicle_id"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "error", limit: 255
    t.integer "user_id"
    t.text "confirmation_status"
    t.text "inquiry_status"
    t.datetime "created", default: -> { "now()" }
    t.datetime "updated", default: -> { "now()" }
  end

  create_table "makes", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "models", id: :serial, force: :cascade do |t|
    t.integer "make_id"
    t.string "name", limit: 255
    t.index ["make_id"], name: "index_models_on_make_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "slug", limit: 255
    t.string "name", limit: 255
    t.boolean "active"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "featured"
    t.datetime "deleted_at"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vehicle_id"
    t.integer "vehicles_photo_id"
    t.boolean "featured", default: false
    t.string "name", default: ""
    t.boolean "uploaded", default: false
    t.index ["vehicle_id"], name: "index_photos_on_vehicle_id"
  end

  create_table "purchases", id: :serial, force: :cascade do |t|
    t.integer "subscriber_id"
    t.integer "vehicle_id"
    t.float "price"
    t.float "profit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source", limit: 255
  end

  create_table "requests", id: :serial, force: :cascade do |t|
    t.integer "subscriber_id"
    t.integer "vehicle_id"
    t.integer "body_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["body_type_id"], name: "index_requests_on_body_type_id"
    t.index ["subscriber_id"], name: "index_requests_on_subscriber_id"
    t.index ["vehicle_id"], name: "index_requests_on_vehicle_id"
  end

  create_table "roles", primary_key: ["user_id", "name"], force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "name", null: false
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "subscribers", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255
    t.string "phone", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "token", limit: 255
    t.boolean "confirmed"
    t.datetime "sent_at"
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "subscription_plan", limit: 255
    t.datetime "opted_in_at"
    t.string "source", limit: 255
    t.string "email_errors", limit: 255, default: ""
  end

  create_table "subscribers_vehicles", id: false, force: :cascade do |t|
    t.integer "subscriber_id"
    t.integer "vehicle_id"
    t.index ["subscriber_id", "vehicle_id"], name: "index_subscribers_vehicles_on_subscriber_id_and_vehicle_id", unique: true
  end

  create_table "suspensions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "titles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "body"
    t.datetime "deleted_at"
  end

  create_table "transmissions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "login"
    t.string "email", limit: 255, null: false
    t.string "crypted_password"
    t.string "password_salt"
    t.string "persistence_token"
    t.string "perishable_token"
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string "current_login_ip", limit: 255
    t.string "last_login_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.text "nickname"
    t.text "name"
    t.text "picture"
    t.text "auth_id"
    t.datetime "last_login"
    t.text "roles"
    t.text "first_name"
    t.text "last_name"
    t.datetime "created", default: -> { "now()" }
    t.datetime "updated", default: -> { "now()" }
    t.index ["auth_id"], name: "users_auth_id_key", unique: true
  end

  create_table "vehicle_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", id: :serial, force: :cascade do |t|
    t.integer "year"
    t.integer "make_id"
    t.integer "model_id"
    t.string "subtitle", limit: 255
    t.string "ebay", limit: 255
    t.string "stock_number", limit: 255
    t.string "vin", limit: 255
    t.integer "warranty_id"
    t.integer "title_id"
    t.string "engine_type", limit: 255
    t.integer "transmission_id"
    t.integer "miles"
    t.integer "ext_color_id"
    t.integer "int_color_id"
    t.integer "status_id"
    t.integer "price"
    t.integer "damage_id"
    t.integer "exterior_id"
    t.integer "interior_id"
    t.integer "drivable_id"
    t.integer "engine_id"
    t.integer "suspension_id"
    t.boolean "stains", default: false
    t.boolean "burns", default: false
    t.boolean "tears", default: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "featured_id"
    t.boolean "featured", default: false
    t.boolean "sold", default: false
    t.integer "body_type_id"
    t.text "make"
    t.text "model"
    t.integer "featured_photo"
    t.integer "retail_price"
    t.integer "has_price", default: 0, null: false
    t.index ["body_type_id"], name: "index_vehicles_on_body_type_id"
    t.index ["damage_id"], name: "index_vehicles_on_damage_id"
    t.index ["drivable_id"], name: "index_vehicles_on_drivable_id"
    t.index ["engine_id"], name: "index_vehicles_on_engine_id"
    t.index ["ext_color_id"], name: "index_vehicles_on_ext_color_id"
    t.index ["exterior_id"], name: "index_vehicles_on_paint_id"
    t.index ["int_color_id"], name: "index_vehicles_on_int_color_id"
    t.index ["interior_id"], name: "index_vehicles_on_interior_id"
    t.index ["make_id"], name: "index_vehicles_on_make_id"
    t.index ["model_id"], name: "index_vehicles_on_model_id"
    t.index ["status_id"], name: "index_vehicles_on_status_id"
    t.index ["suspension_id"], name: "index_vehicles_on_suspension_id"
    t.index ["title_id"], name: "index_vehicles_on_title_id"
    t.index ["transmission_id"], name: "index_vehicles_on_trans_id"
    t.index ["warranty_id"], name: "index_vehicles_on_warranty_id"
  end

  create_table "vehicles_disclosures", id: false, force: :cascade do |t|
    t.integer "vehicle_id", null: false
    t.integer "disclosure_id", null: false
    t.index ["vehicle_id", "disclosure_id"], name: "index_vehicles_disclosures_on_vehicle_id_and_disclosure_id", unique: true
  end

  create_table "vehicles_features", id: false, force: :cascade do |t|
    t.integer "vehicle_id"
    t.integer "feature_id"
    t.index ["vehicle_id", "feature_id"], name: "index_vehicles_features_on_vehicle_id_and_feature_id"
  end

  create_table "warranties", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "body"
    t.datetime "deleted_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "body_types", "vehicle_types", name: "body_types_vehicle_type_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "inquiries", "subscribers", name: "inquiries_subscriber_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "inquiries", "users", name: "inquiries_user_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "inquiries", "vehicles", name: "inquiries_vehicle_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "photos", "vehicles", name: "photos_vehicle_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "purchases", "subscribers", name: "purchases_subscriber_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "purchases", "vehicles", name: "purchases_vehicle_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "requests", "body_types", name: "requests_body_type_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "requests", "subscribers", name: "requests_subscriber_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "requests", "vehicles", name: "requests_vehicle_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "roles", "users", name: "roles_user_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "subscribers_vehicles", "subscribers", name: "subscribers_vehicles_subscriber_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "subscribers_vehicles", "vehicles", name: "subscribers_vehicles_vehicle_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "body_types", name: "vehicles_body_type_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "colors", column: "ext_color_id", name: "vehicles_ext_color_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "colors", column: "int_color_id", name: "vehicles_int_color_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "conditions", column: "exterior_id", name: "vehicles_exterior_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "conditions", column: "interior_id", name: "vehicles_interior_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "damages", name: "vehicles_damage_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "drivables", name: "vehicles_drivable_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "engines", name: "vehicles_engine_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "makes", name: "vehicles_make_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "models", name: "vehicles_model_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "statuses", name: "vehicles_status_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "suspensions", name: "vehicles_suspension_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "titles", name: "vehicles_title_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "transmissions", name: "vehicles_transmission_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles", "warranties", name: "vehicles_warranty_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles_disclosures", "disclosures", name: "vehicles_disclosures_disclosure_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles_disclosures", "vehicles", name: "vehicles_disclosures_vehicle_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles_features", "features", name: "vehicles_features_feature_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "vehicles_features", "vehicles", name: "vehicles_features_vehicle_id_fkey", on_update: :restrict, on_delete: :restrict
end
