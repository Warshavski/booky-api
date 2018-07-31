class CreateStocks < ActiveRecord::Migration[5.1]
  def change

    # I'am not sure how to mark book as out of stock.
    # Should we use some boolean flag to indicate that the current book is
    # out of stock or just update quantity field to zero.
    #
    # In first case, we can simply mark the book and stop any sales for a period of time,
    # and then reopen the sales again(we are not sure that the current quantity will be enough and order a little more)
    #
    create_table :stocks do |t|
      t.references :book, null: false
      t.references :shop, null: false

      t.integer :quantity, null: false, default: 0

      t.column :created_at, 'timestamp with time zone', null: false
      t.column :updated_at, 'timestamp with time zone', null: false
    end
  end
end
