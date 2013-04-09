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

ActiveRecord::Schema.define(:version => 20130409204526) do

  create_table "colors", :force => true do |t|
    t.string "name"
  end

  create_table "conditions", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "damages", :force => true do |t|
    t.string "name"
  end

  create_table "drivables", :force => true do |t|
    t.string "name"
  end

  create_table "engines", :force => true do |t|
    t.string "name"
  end

  create_table "features", :force => true do |t|
    t.string "name"
  end

  create_table "makes", :force => true do |t|
    t.string "name"
  end

  create_table "models", :force => true do |t|
    t.integer "make_id"
    t.string  "name"
  end

  create_table "prices", :force => true do |t|
    t.string "amount"
  end

  create_table "statuses", :force => true do |t|
    t.string "name"
  end

  create_table "suspensions", :force => true do |t|
    t.string "name"
  end

  create_table "titles", :force => true do |t|
    t.string "name"
  end

  create_table "transmissions", :force => true do |t|
    t.string "name"
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
    t.integer  "trans_id"
    t.integer  "miles"
    t.integer  "ext_color_id"
    t.integer  "int_color_id"
    t.integer  "status_id"
    t.integer  "price"
    t.integer  "damage_id"
    t.integer  "paint_id"
    t.integer  "interior_id"
    t.integer  "drivable_id"
    t.integer  "engine_id"
    t.integer  "suspension_id"
    t.boolean  "stains"
    t.boolean  "burns"
    t.boolean  "tears"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "vehicles_features", :id => false, :force => true do |t|
    t.integer "vehicle_id"
    t.integer "feature_id"
  end

  add_index "vehicles_features", ["vehicle_id", "feature_id"], :name => "index_vehicles_features_on_vehicle_id_and_feature_id"

  create_table "warranties", :force => true do |t|
    t.string "name"
  end

end
