# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130926180251) do

  create_table "body_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "body"
    t.datetime "deleted_at"
  end

  create_table "colors", :force => true do |t|
    t.string "name"
  end

  create_table "conditions", :force => true do |t|
    t.string "name"
  end

  create_table "damages", :force => true do |t|
    t.string "name"
  end

  create_table "disclosures", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "drivables", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "deleted_at"
  end

  create_table "engines", :force => true do |t|
    t.string "name"
  end

  create_table "features", :force => true do |t|
    t.string   "name"
    t.integer  "order"
    t.datetime "deleted_at"
  end

  create_table "makes", :force => true do |t|
    t.string "name"
  end

  create_table "models", :force => true do |t|
    t.integer "make_id"
    t.string  "name"
  end

  add_index "models", ["make_id"], :name => "index_models_on_make_id"

  create_table "pages", :force => true do |t|
    t.string   "slug"
    t.string   "name"
    t.boolean  "active"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "featured"
    t.datetime "deleted_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "vehicle_id"
    t.integer  "vehicles_photo_id"
    t.datetime "deleted_at"
    t.string   "vehicle_string"
  end

  add_index "photos", ["vehicle_id"], :name => "index_photos_on_vehicle_id"

  create_table "requests", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "vehicle_id"
    t.integer  "body_type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.datetime "deleted_at"
  end

  add_index "requests", ["body_type_id"], :name => "index_requests_on_body_type_id"
  add_index "requests", ["subscriber_id"], :name => "index_requests_on_subscriber_id"
  add_index "requests", ["vehicle_id"], :name => "index_requests_on_vehicle_id"

  create_table "statuses", :force => true do |t|
    t.string "name"
  end

  create_table "subscribers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.datetime "deleted_at"
    t.string   "confirmation_code"
    t.boolean  "confirmed"
    t.datetime "sent_at"
  end

  create_table "suspensions", :force => true do |t|
    t.string "name"
  end

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "deleted_at"
  end

  create_table "transmissions", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                             :null => false
    t.string   "email",                             :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.string   "persistence_token",                 :null => false
    t.string   "perishable_token",                  :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.datetime "deleted_at"
  end

  create_table "vehicles", :force => true do |t|
    t.integer  "year"
    t.integer  "make_id"
    t.integer  "model_id"
    t.string   "subtitle"
    t.string   "ebay"
    t.string   "stock_number"
    t.string   "vin"
    t.integer  "warranty_id"
    t.integer  "title_id"
    t.string   "engine_type"
    t.integer  "transmission_id"
    t.integer  "miles"
    t.integer  "ext_color_id"
    t.integer  "int_color_id"
    t.integer  "status_id"
    t.integer  "price"
    t.integer  "damage_id"
    t.integer  "exterior_id"
    t.integer  "interior_id"
    t.integer  "drivable_id"
    t.integer  "engine_id"
    t.integer  "suspension_id"
    t.boolean  "stains",          :default => false
    t.boolean  "burns",           :default => false
    t.boolean  "tears",           :default => false
    t.text     "description"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "deleted_at"
    t.integer  "featured_id"
    t.boolean  "featured",        :default => false
    t.boolean  "sold",            :default => false
    t.integer  "body_type_id"
  end

  add_index "vehicles", ["body_type_id"], :name => "index_vehicles_on_body_type_id"
  add_index "vehicles", ["damage_id"], :name => "index_vehicles_on_damage_id"
  add_index "vehicles", ["drivable_id"], :name => "index_vehicles_on_drivable_id"
  add_index "vehicles", ["engine_id"], :name => "index_vehicles_on_engine_id"
  add_index "vehicles", ["ext_color_id"], :name => "index_vehicles_on_ext_color_id"
  add_index "vehicles", ["exterior_id"], :name => "index_vehicles_on_paint_id"
  add_index "vehicles", ["int_color_id"], :name => "index_vehicles_on_int_color_id"
  add_index "vehicles", ["interior_id"], :name => "index_vehicles_on_interior_id"
  add_index "vehicles", ["make_id"], :name => "index_vehicles_on_make_id"
  add_index "vehicles", ["model_id"], :name => "index_vehicles_on_model_id"
  add_index "vehicles", ["status_id"], :name => "index_vehicles_on_status_id"
  add_index "vehicles", ["suspension_id"], :name => "index_vehicles_on_suspension_id"
  add_index "vehicles", ["title_id"], :name => "index_vehicles_on_title_id"
  add_index "vehicles", ["transmission_id"], :name => "index_vehicles_on_trans_id"
  add_index "vehicles", ["warranty_id"], :name => "index_vehicles_on_warranty_id"

  create_table "vehicles_disclosures", :id => false, :force => true do |t|
    t.integer "vehicle_id",    :null => false
    t.integer "disclosure_id", :null => false
  end

  add_index "vehicles_disclosures", ["vehicle_id", "disclosure_id"], :name => "index_vehicles_disclosures_on_vehicle_id_and_disclosure_id", :unique => true

  create_table "vehicles_features", :id => false, :force => true do |t|
    t.integer "vehicle_id"
    t.integer "feature_id"
  end

  add_index "vehicles_features", ["vehicle_id", "feature_id"], :name => "index_vehicles_features_on_vehicle_id_and_feature_id"

  create_table "warranties", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "deleted_at"
  end

end
