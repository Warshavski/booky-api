class CreateBooksGenres < ActiveRecord::Migration[5.1]
  def change
    create_table :books_genres, id: false do |t|
      t.references :book,   foreign_key: true
      t.references :genre,  foreign_key: true
    end

    add_index :books_genres, %i[book_id genre_id]
  end
end
