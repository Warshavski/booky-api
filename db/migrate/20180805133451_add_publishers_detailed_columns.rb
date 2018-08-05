class AddPublishersDetailedColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :publishers, :description, :text, null: true

    add_column :publishers, :email, :string, null: true
    add_column :publishers, :phone, :string, null: true

    add_column :publishers, :address,   :string, null: true
    add_column :publishers, :postcode,  :string, null: true
  end
end
