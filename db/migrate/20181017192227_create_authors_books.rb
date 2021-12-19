class CreateAuthorsBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :authors_books, id: false do |t|
      t.references :book,    foreign_key: true
      t.references :author,  foreign_key: true
    end

    add_index :authors_books, %i[book_id author_id]
  end
end
