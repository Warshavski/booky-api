class CreateAuthorsBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :authors_books, id: false do |t|
      t.references :book,    null: false
      t.references :author,  null: false
    end
  end
end
