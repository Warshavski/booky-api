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

ActiveRecord::Schema.define(version: 2018_10_24_120408) do

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
    t.index ["first_name", "last_name"], name: "index_authors_on_first_name_and_last_name"
  end

  create_table "books", force: :cascade do |t|
    t.bigint "publisher_id"
    t.string "title", null: false
    t.integer "weight", default: 0, null: false
    t.integer "pages_count", default: 0, null: false
    t.text "description"
    t.string "isbn13", limit: 13
    t.string "isbn10", limit: 10
    t.date "published_in", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["isbn10"], name: "index_books_on_isbn10", unique: true
    t.index ["isbn13"], name: "index_books_on_isbn13", unique: true
    t.index ["published_in"], name: "index_books_on_published_in"
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
    t.index ["title"], name: "index_books_on_title"
  end

  create_table "books_authors", id: false, force: :cascade do |t|
    t.bigint "book_id"
    t.bigint "author_id"
    t.index ["author_id"], name: "index_books_authors_on_author_id"
    t.index ["book_id", "author_id"], name: "index_books_authors_on_book_id_and_author_id", unique: true
    t.index ["book_id"], name: "index_books_authors_on_book_id"
  end

  create_table "books_genres", id: false, force: :cascade do |t|
    t.bigint "book_id"
    t.bigint "genre_id"
    t.index ["book_id", "genre_id"], name: "index_books_genres_on_book_id_and_genre_id", unique: true
    t.index ["book_id"], name: "index_books_genres_on_book_id"
    t.index ["genre_id"], name: "index_books_genres_on_genre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "phone"
    t.string "address"
    t.string "postcode"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_publishers_on_name", unique: true
  end

  add_foreign_key "books", "publishers"
  add_foreign_key "books_authors", "authors"
  add_foreign_key "books_authors", "books"
  add_foreign_key "books_genres", "books"
  add_foreign_key "books_genres", "genres"
end
