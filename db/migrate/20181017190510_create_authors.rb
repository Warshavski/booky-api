class CreateAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :first_name, null: false
      t.string :last_name,  null: false

      t.text :biography, null: true

      t.date :born_in, null: true
      t.date :died_in, null: true

      t.timestamps
    end

    add_index :authors, %i[first_name last_name]
  end
end
