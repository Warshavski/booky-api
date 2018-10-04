class AddBooksDetailedColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :isbn_13, :string, limit: 10
    add_column :books, :isbn_10, :string, limit: 13
    add_column :books, :published_at, :date, null: true

    # Renew publish date for books that already was in table
    date = Date.new(1111, 11, 11)
    update "UPDATE books SET published_at = '#{date}'"

    change_column_null :books, :published_at, false
  end
end
