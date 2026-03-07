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

ActiveRecord::Schema[8.0].define(version: 2026_03_06_120001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "catch_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "facility_id", null: false
    t.bigint "lure_id"
    t.decimal "size_cm", precision: 5, scale: 1
    t.string "fish_species"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.decimal "depth_m", precision: 5, scale: 2
    t.jsonb "fishing_method_data", default: {}
    t.text "memo"
    t.datetime "caught_at", null: false
    t.time "stocking_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "fishing_session_id"
    t.string "weather"
    t.string "wind_strength"
    t.index ["caught_at"], name: "index_catch_records_on_caught_at"
    t.index ["facility_id"], name: "index_catch_records_on_facility_id"
    t.index ["fishing_method_data"], name: "index_catch_records_on_fishing_method_data", using: :gin
    t.index ["fishing_session_id"], name: "index_catch_records_on_fishing_session_id"
    t.index ["lure_id"], name: "index_catch_records_on_lure_id"
    t.index ["user_id"], name: "index_catch_records_on_user_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.string "place_id"
    t.string "phone_number"
    t.string "website_url"
    t.text "description"
    t.string "prefecture"
    t.boolean "is_verified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_facilities_on_latitude_and_longitude"
    t.index ["place_id"], name: "index_facilities_on_place_id", unique: true
    t.index ["prefecture"], name: "index_facilities_on_prefecture"
  end

  create_table "fishing_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "facility_id", null: false
    t.date "fished_on"
    t.string "weather"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "weather_am"
    t.string "weather_pm"
    t.string "water_condition"
    t.string "pond_number"
    t.index ["facility_id"], name: "index_fishing_sessions_on_facility_id"
    t.index ["user_id"], name: "index_fishing_sessions_on_user_id"
  end

  create_table "lures", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "lure_type", default: 0, null: false
    t.string "color_front", default: "#ffffff", null: false
    t.string "color_back", default: "#ffffff", null: false
    t.decimal "weight", precision: 5, scale: 2
    t.integer "buoyancy", default: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lure_type"], name: "index_lures_on_lure_type"
    t.index ["user_id"], name: "index_lures_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "catch_records", "facilities"
  add_foreign_key "catch_records", "fishing_sessions"
  add_foreign_key "catch_records", "lures"
  add_foreign_key "catch_records", "users"
  add_foreign_key "fishing_sessions", "facilities"
  add_foreign_key "fishing_sessions", "users"
  add_foreign_key "lures", "users"
end
