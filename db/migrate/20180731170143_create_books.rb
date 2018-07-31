class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string  :title, null: false
      t.text    :description

      t.references :publisher, null: false

      t.column :created_at, 'timestamp with time zone', null: false
      t.column :updated_at, 'timestamp with time zone', null: false
    end
  end
end
