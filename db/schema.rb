ActiveRecord::Schema[8.1].define(version: 2026_04_16_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "catch_records", force: :cascade do |t|
    t.datetime "caught_at", null: false
    t.datetime "created_at", null: false
    t.decimal "depth_m", precision: 5, scale: 2
    t.bigint "facility_id", null: false
    t.string "fish_species"
    t.jsonb "fishing_method_data", default: {}
    t.bigint "fishing_session_id"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.bigint "lure_id"
    t.text "memo"
    t.decimal "size_cm", precision: 5, scale: 1
    t.time "stocking_time"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
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
    t.string "address"
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "is_verified", default: false
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.string "name", null: false
    t.string "phone_number"
    t.string "place_id"
    t.string "prefecture"
    t.datetime "updated_at", null: false
    t.string "website_url"
    t.index ["latitude", "longitude"], name: "index_facilities_on_latitude_and_longitude"
    t.index ["place_id"], name: "index_facilities_on_place_id", unique: true
    t.index ["prefecture"], name: "index_facilities_on_prefecture"
  end

  create_table "fishing_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "facility_id", null: false
    t.date "fished_on"
    t.text "memo"
    t.string "pond_number"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "water_condition"
    t.string "weather"
    t.string "weather_am"
    t.string "weather_pm"
    t.index ["facility_id"], name: "index_fishing_sessions_on_facility_id"
    t.index ["user_id"], name: "index_fishing_sessions_on_user_id"
  end

  create_table "lures", force: :cascade do |t|
    t.integer "buoyancy", default: 3
    t.string "color_back", default: "#ffffff", null: false
    t.string "color_front", default: "#ffffff", null: false
    t.datetime "created_at", null: false
    t.integer "lure_type", default: 0, null: false
    t.string "manufacturer"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.decimal "weight", precision: 5, scale: 2
    t.index ["lure_type"], name: "index_lures_on_lure_type"
    t.index ["user_id"], name: "index_lures_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
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
