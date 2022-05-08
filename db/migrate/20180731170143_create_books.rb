class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.references :publisher, foreign_key: true, index: true

      t.string  :title,       null: false, index: true
      t.decimal :weight,      null: true
      t.integer :pages_count, null: false, default: 0
      t.text    :description, null: true

      t.string :isbn13, limit: 13, null: true, index: { unique: true }
      t.string :isbn10, limit: 10, null: true, index: { unique: true }

      t.date :published_at, null: false, index: true

      t.timestamps
    end
  end
end
