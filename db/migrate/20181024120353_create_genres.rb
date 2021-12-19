class CreateGenres < ActiveRecord::Migration[5.1]
  def change
    create_table :genres do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description, null: true

      t.timestamps
    end
  end
end
