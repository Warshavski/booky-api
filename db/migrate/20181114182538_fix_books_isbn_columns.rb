class FixBooksIsbnColumns < ActiveRecord::Migration[5.1]
  def change
    change_column :books, :isbn_13, :string, limit: 13
    change_column :books, :isbn_10, :string, limit: 10
  end
end
