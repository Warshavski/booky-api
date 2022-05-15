class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.references :publisher, foreign_key: true, index: true

      t.string  :title,       null: false, index: true
      t.integer :weight,      null: false, default: 0
      t.integer :pages_count, null: false, default: 0
      t.text    :description, null: true

      t.string :isbn13, limit: 13, null: true, index: { unique: true }
      t.string :isbn10, limit: 10, null: true, index: { unique: true }

      t.date :published_in, null: false, index: true

      t.timestamps
    end
  end
end
