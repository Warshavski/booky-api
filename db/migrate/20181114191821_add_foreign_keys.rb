class AddForeignKeys < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :books, :publishers, on_delete: :nullify

    add_foreign_key :authors_books, :authors, on_delete: :cascade
    add_foreign_key :authors_books, :books,   on_delete: :cascade

    add_foreign_key :books_genres, :books,  on_delete: :cascade
    add_foreign_key :books_genres, :genres, on_delete: :cascade
  end
end
