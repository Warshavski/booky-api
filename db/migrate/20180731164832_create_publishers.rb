class CreatePublishers < ActiveRecord::Migration[5.1]
  def change
    create_table :publishers do |t|
      t.string :name, null: false, index: { unique: true }

      t.string :email,    null: true
      t.string :phone,    null: true
      t.string :address,  null: true
      t.string :postcode, null: true

      t.text :description, null: true

      t.timestamps
    end
  end
end
