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

ActiveRecord::Schema.define(version: 20181204152253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.text "biography"
    t.date "born_in"
    t.date "died_in"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors_books", id: false, force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "author_id", null: false
    t.index ["author_id"], name: "index_authors_books_on_author_id"
    t.index ["book_id"], name: "index_authors_books_on_book_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "publisher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "isbn_13", limit: 13
    t.string "isbn_10", limit: 10
    t.date "published_at", null: false
    t.decimal "weight"
    t.integer "pages_count", default: 0, null: false
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
  end

  create_table "books_genres", id: false, force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "genre_id", null: false
    t.index ["book_id", "genre_id"], name: "index_books_genres_on_book_id_and_genre_id", unique: true
    t.index ["genre_id"], name: "index_books_genres_on_genre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.string "postcode"
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "shop_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_sales_on_book_id"
    t.index ["shop_id"], name: "index_sales_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "shop_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_stocks_on_book_id"
    t.index ["shop_id"], name: "index_stocks_on_shop_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.bigint "size", null: false
    t.string "path", limit: 511, null: false
    t.string "checksum", limit: 64
    t.string "model_type"
    t.bigint "model_id"
    t.string "uploader", null: false
    t.string "mount_point"
    t.string "secret"
    t.integer "store"
    t.datetime "created_at", null: false
    t.index ["checksum"], name: "index_uploads_on_checksum"
    t.index ["model_id", "model_type"], name: "index_uploads_on_model_id_and_model_type"
    t.index ["model_type", "model_id"], name: "index_uploads_on_model_type_and_model_id"
    t.index ["path"], name: "index_uploads_on_path"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "bio", limit: 255
    t.string "avatar"
    t.boolean "admin", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "banned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "authors_books", "authors", on_delete: :cascade
  add_foreign_key "authors_books", "books", on_delete: :cascade
  add_foreign_key "books", "publishers", on_delete: :nullify
  add_foreign_key "books_genres", "books", on_delete: :cascade
  add_foreign_key "books_genres", "genres", on_delete: :cascade
end
