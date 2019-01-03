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

ActiveRecord::Schema.define(version: 2019_01_02_150228) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
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

  create_table "authorizations", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "phone"
    t.date "requested_date"
    t.integer "no_of_guests"
    t.time "requested_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id"
    t.integer "table_id"
    t.time "end_time"
    t.date "end_date"
    t.boolean "validity", default: true
    t.string "encrypt_id"
    t.integer "user_id"
    t.index ["restaurant_id"], name: "index_bookings_on_restaurant_id"
    t.index ["table_id"], name: "index_bookings_on_table_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "longitude"
    t.decimal "latitude"
    t.string "city"
    t.string "address"
    t.string "street"
    t.string "country"
    t.string "state"
    t.string "full_address"
    t.integer "user_id"
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.text "item"
    t.integer "total"
    t.string "full_address"
    t.integer "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "quantity"
    t.text "hashing"
    t.time "start_time"
    t.time "end_time"
    t.integer "user_id"
    t.string "email"
    t.integer "phone"
    t.string "encrypt_id"
    t.boolean "validity", default: true
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.integer "restaurant_id"
    t.boolean "approved", default: false
    t.string "permalinks"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.text "food_menu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.string "category"
    t.string "restaurant_image"
    t.string "situated_at"
    t.string "food_item"
    t.index ["location_id"], name: "index_restaurants_on_location_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.float "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "restaurant_id"
    t.boolean "approved"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "tables", force: :cascade do |t|
    t.integer "four_seater"
    t.integer "six_seater"
    t.integer "two_seater"
    t.integer "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_tables_on_restaurant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "password_digest"
    t.string "password_confirmation"
    t.string "password"
    t.string "name"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.string "remember_digest"
  end

end
