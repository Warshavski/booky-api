class CreateBooksGenres < ActiveRecord::Migration[5.1]
  def change
    create_table :books_genres, id: false do |t|
      t.references :book,   null: false, index: false
      t.references :genre,  null: false, index: false
    end

    add_index :books_genres, %i[book_id genre_id], unique: true
    add_index :books_genres, :genre_id
  end
end
