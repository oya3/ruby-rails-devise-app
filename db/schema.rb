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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170702114808) do

  create_table "between_train_route_stations", force: :cascade do |t|
    t.integer  "train_route_station1_id"
    t.integer  "train_route_station2_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["train_route_station1_id"], name: "index_between_train_route_stations_on_train_route_station1_id"
    t.index ["train_route_station2_id"], name: "index_between_train_route_stations_on_train_route_station2_id"
  end

  create_table "points", force: :cascade do |t|
    t.integer  "railway_id"
    t.decimal  "lat",        precision: 11, scale: 8
    t.decimal  "lng",        precision: 11, scale: 8
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["railway_id"], name: "index_points_on_railway_id"
  end

  create_table "railsection_railways", force: :cascade do |t|
    t.integer  "railsection_id"
    t.integer  "railway_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["railsection_id"], name: "index_railsection_railways_on_railsection_id"
    t.index ["railway_id"], name: "index_railsection_railways_on_railway_id"
  end

  create_table "railsections", force: :cascade do |t|
    t.text     "name"
    t.integer  "railsectionable_id"
    t.string   "railsectionable_type"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["railsectionable_type", "railsectionable_id"], name: "index_railsections_00"
  end

  create_table "railways", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "stations", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_stations_on_code", unique: true
  end

  create_table "train_route_stations", force: :cascade do |t|
    t.integer  "train_route_id"
    t.integer  "station_id"
    t.integer  "row_order"
    t.integer  "distance"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["station_id"], name: "index_train_route_stations_on_station_id"
    t.index ["train_route_id"], name: "index_train_route_stations_on_train_route_id"
  end

  create_table "train_routes", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_train_routes_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

end
