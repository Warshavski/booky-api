class CreateBooksAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :books_authors, id: false do |t|
      t.references :book,    foreign_key: true
      t.references :author,  foreign_key: true
    end

    add_index :books_authors, %i[book_id author_id], unique: true
  end
end
